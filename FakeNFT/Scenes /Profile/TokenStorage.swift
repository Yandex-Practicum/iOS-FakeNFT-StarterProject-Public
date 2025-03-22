//
//  TokenStorage.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 20.03.2025.
//

import Security
import Foundation

typealias Token = String

protocol TokenStorage {
    func store(token: Token) throws
    func retrieveToken() throws -> Token
    func deleteToken() throws
}

enum TokenKeychainStorageError: Error {
    case storeError
    case retrieveError
    case deleteError
    
    var localizedDescription: String {
        switch self {
        case .storeError:
            "Failed to store token"
        case .retrieveError:
            "Failed to retrieve token"
        case .deleteError:
            "Failed to delete token"
        }
    }
}

final class TokenKeychainStorage: TokenStorage {
    private let tag = "com.FakeNFT.token"
    private let key = "userToken"
    
    func store(token: String) throws {
        guard let tokenData = token.data(using: .utf8) else { throw TokenKeychainStorageError.storeError }
        
        try? deleteToken()
        
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: tag,
            kSecValueData as String: tokenData
        ]
        
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else { throw TokenKeychainStorageError.storeError }
    }
    
    func retrieveToken() throws -> String {
        let getQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: tag,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        
        guard status == errSecSuccess, let tokenData = item as? Data, let token = String(data: tokenData, encoding: .utf8) else {
            throw TokenKeychainStorageError.retrieveError
        }
        
        return token
    }
    
    func deleteToken() throws {
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: tag
        ]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw TokenKeychainStorageError.deleteError
        }
    }
}

