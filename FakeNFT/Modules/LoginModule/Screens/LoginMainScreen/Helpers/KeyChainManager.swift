//
//  KeyChainManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 11.07.2023.
//

import Foundation

protocol SecureDataProtocol {
    func checkCredentials(username: String, password: String) -> Bool
    func saveValue(_ value: String, forKey key: String) -> Bool
    func getValue(forKey key: String) -> String?
}

final class KeyChainManager {
    private let service: String
    
    init(service: String) {
        self.service = service
    }
}

// MARK: - Ext SecureDataProtocol
extension KeyChainManager: SecureDataProtocol {
    func checkCredentials(username: String, password: String) -> Bool {
            if let savedPassword = getValue(forKey: username), savedPassword == password {
                // Username and password are correct
                return true
            } else {
                // Username or password is incorrect
                return false
            }
        }
    
    func saveValue(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getValue(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
}
