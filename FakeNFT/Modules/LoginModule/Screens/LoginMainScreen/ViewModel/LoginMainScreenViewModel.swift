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
            requestResult = .failure
            return
        }
        
        sendLoginRequest(name: name, password: password)
        
    }
    
    func register(with userCredentials: LoginCredentials) {
        changeActionTypeOrRegister(with: userCredentials)
    }
}

// MARK: - Ext Private
private extension LoginMainScreenViewModel {
    func changeActionTypeOrRegister(with userCredentials: LoginCredentials) {
        actionType == .login ? switchToRegister() : sendRegisterRequest(with: userCredentials)
    }
    
    func switchToRegister() {
        actionType = .register
    }
    
    func sendLoginRequest(name: String, password: String) {
        requestResult = .loading
        let isLoggedIn = keyChainManager.checkCredentials(username: name, password: password)

        proceedLogin(isLoggedIn)
    }
    
    func sendRegisterRequest(with userCredentials: LoginCredentials) {
        guard
            let name = userCredentials.email,
            !name.isEmpty,
            let password = userCredentials.password,
            !password.isEmpty
        else {
            requestResult = .failure
            return
        }
        
        requestResult = .loading
        userExists(name) ? proceedLogin(false) : proceedLogin(keyChainManager.saveValue(password, forKey: name))
    }
    
    func userExists(_ name: String) -> Bool {
        keyChainManager.checkIfUserExists(username: name)
    }
    
    func userSaved(name: String, password: String) -> Bool {
        keyChainManager.saveValue(password, forKey: name)
    }
    
    func proceedLogin(_ isLoggedIn: Bool) {
        // mock loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            isLoggedIn ? self?.loginSuccess() : self?.loginFailure()
        }
    }
    
    func loginFailure() {
        requestResult = .failure
    }
    
    func loginSuccess() {
        requestResult = .success
    }
}
