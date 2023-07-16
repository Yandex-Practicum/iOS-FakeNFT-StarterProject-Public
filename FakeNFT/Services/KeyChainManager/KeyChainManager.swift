//
//  KeyChainManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 11.07.2023.
//

import Foundation

protocol SecureDataProtocol {
    func checkIfUserExists(username: String) -> Bool
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
    
    func checkIfUserExists(username: String) -> Bool {
        // Create a dictionary of attributes to search for.
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
        ]
        
        // Try to find the item in the keychain.
        var item: AnyObject?
        let status = SecItemCopyMatching(attributes as CFDictionary, &item)
        
        return status == errSecSuccess ? true : false
    }
    
    func checkCredentials(username: String, password: String) -> Bool {
            if let savedPassword = getValue(forKey: username), savedPassword == password {
                return true
            } else {
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
