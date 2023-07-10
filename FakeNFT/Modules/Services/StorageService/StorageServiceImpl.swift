//
//  StorageServiceImpl.swift
//  FakeNFT
//
//  Created by Kirill on 10.07.2023.
//

import Foundation

class StorageServiceImpl: StorageService {
    private let userDefaults = UserDefaults.standard

    func set<T>(key: String, value: T?) {
        userDefaults.set(value, forKey: key)
    }

    func get<T>(key: String) -> T? {
        userDefaults.object(forKey: key) as? T
    }

    func removeObject(key: String) {
        userDefaults.removeObject(forKey: key)
    }
}

