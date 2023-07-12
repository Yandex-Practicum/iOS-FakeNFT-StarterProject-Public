//
//  ResetPasswordViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 12.07.2023.
//

import Foundation
import Combine

final class ResetPasswordViewModel {
    
    @Published private (set) var passwordResetResult: RequestResult?
    
    let keyChainManager: SecureDataProtocol
    
    // MARK: Init
    init(keyChainManager: SecureDataProtocol) {
        self.keyChainManager = keyChainManager
    }
    
    func resetPassword(for name: String?) {
        guard let name else { return }
        passwordResetResult = .loading
        keyChainManager.checkIfUserExists(username: name) ? resetSuccess() : resetFailed()
    }
}
// MARK: - Ext Private
private extension ResetPasswordViewModel {
    func resetSuccess() {
        passwordResetResult = .success
    }
    
    func resetFailed() {
        passwordResetResult = .failure
    }
}
