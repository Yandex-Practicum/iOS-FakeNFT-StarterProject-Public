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
    
    let networkClient: NetworkClient
    let keyChainManager: SecureDataProtocol
    
    init(networkClient: NetworkClient, keyChainManager: SecureDataProtocol) {
        self.networkClient = networkClient
        self.keyChainManager = keyChainManager
    }
    
    func enterProfile(with userCredentials: LoginCredentials) {
        guard
            let name = userCredentials.email,
            let password = userCredentials.password
        else {
            requestResult = .failure
            return
        }
        
        sendLoginRequest(name: name, password: password)
        
    }
}

// MARK: - Ext Private
private extension LoginMainScreenViewModel {
    func sendLoginRequest(name: String, password: String) {
        requestResult = .loading
        let isLoggedIn = keyChainManager.checkCredentials(username: name, password: password)

        proceedLogin(isLoggedIn)
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
