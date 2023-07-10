//
//  StorageService.swift
//  FakeNFT
//
//  Created by Kirill on 10.07.2023.
//

import Foundation

protocol StorageService {
    func get<T>(key: String) -> T?
    func set<T>(key: String, value: T?)
    func removeObject(key: String)
}
