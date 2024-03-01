//
//  UserDefaultsProtocol.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 01.03.2024.
//

import Foundation

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func string(forKey defaultName: String) -> String?
}

extension UserDefaults: UserDefaultsProtocol {}
