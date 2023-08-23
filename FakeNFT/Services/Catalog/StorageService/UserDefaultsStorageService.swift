//
//  UserDefaultsStorageService.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 02.08.2023.
//

import Foundation

final class UserDefaultsStorageService: StorageService {
    private let userDefaults = UserDefaults.standard

    func set<T>(key: String, value: T?) {
        userDefaults.set(value, forKey: key)
    }

    func get<T>(key: String) -> T? {
        userDefaults.object(forKey: key) as? T
    }

    func deleteObject(key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
