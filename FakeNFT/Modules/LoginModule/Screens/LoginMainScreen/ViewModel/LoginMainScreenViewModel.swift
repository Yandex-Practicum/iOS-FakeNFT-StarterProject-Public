//
//  LoginMainScreenViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 10.07.2023.
//

import Foundation
import Combine

final class LoginMainScreenViewModel {
    
    @Published private (set) var requestResult: RequestResult?
    @Published private (set) var actionType: ActionType = .login
    @Published private (set) var errorMessage: String?
    
    let networkClient: NetworkClient
    let keyChainManager: SecureDataProtocol
    
    init(networkClient: NetworkClient, keyChainManager: SecureDataProtocol) {
        self.networkClient = networkClient
        self.keyChainManager = keyChainManager
        
//        clear()
    }
    
//    func clear() {
//        keyChainManager.clearAllKeychainData()
//        print("Cleared")
//    }
    
    func login(with userCredentials: LoginCredentials) {
        guard
            let name = userCredentials.email,
            let password = userCredentials.password
        else {
            loginFailure(.textFieldEmpty)
            return
        }
        
        sendLoginRequest(name: name, password: password)
        
    }
    
    func register(with userCredentials: LoginCredentials) {
        changeActionTypeOrRegister(with: userCredentials)
    }
}

// MARK: - Ext check register state
private extension LoginMainScreenViewModel {
    func changeActionTypeOrRegister(with userCredentials: LoginCredentials) {
        actionType == .login ? switchToRegister() : sendRegisterRequest(with: userCredentials)
    }
    
    func switchToRegister() {
        actionType = .register
    }
}

// MARK: - Ext Login
private extension LoginMainScreenViewModel {
    func sendLoginRequest(name: String, password: String) {
        requestResult = .loading
        let isLoggedIn = keyChainManager.checkCredentials(username: name, password: password)

        isLoggedIn ? loginSuccess() : loginFailure(.invalidData)
    }
}

// MARK: - Ext register
private extension LoginMainScreenViewModel {
    func sendRegisterRequest(with userCredentials: LoginCredentials) {
        guard
            let userName = userCredentials.email,
            !userName.isEmpty,
            let password = userCredentials.password,
            !password.isEmpty
        else {
            loginFailure(.textFieldEmpty)
            return
        }
        
        requestResult = .loading
        
        guard !userExists(userName) else {
            loginFailure(.userExists)
            return
        }
        
        finishRegistration(userName: userName, password: password) ? loginSuccess() : loginFailure(.internalError)
    }
    
    func finishRegistration(userName: String, password: String) -> Bool {
        keyChainManager.saveValue(password, forKey: userName)
    }
    
    func userExists(_ name: String) -> Bool {
        keyChainManager.checkIfUserExists(username: name)
    }
    
    func userSaved(name: String, password: String) -> Bool {
        keyChainManager.saveValue(password, forKey: name)
    }
}

// MARK: - Login/register result
private extension LoginMainScreenViewModel {
    func loginFailure(_ reason: LoginErrors) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.requestResult = .failure
            self?.errorMessage = reason.message
        }
        
    }
    
    func loginSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.requestResult = .success
        }
        
    }
}
