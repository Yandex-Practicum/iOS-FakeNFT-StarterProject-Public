//
//  TokenManager.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 07/07/2024.
//

import Foundation

final class TokenManager {
    static let shared = TokenManager()
    
    private init() {
        self.token = RequestConstants.tokenValue
    }
    
    var token: String?
}
