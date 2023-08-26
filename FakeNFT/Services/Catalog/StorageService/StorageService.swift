//
//  StorageService.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 02.08.2023.
//

import Foundation

protocol StorageService {
    func get<T>(key: String) -> T?
    func set<T>(key: String, value: T?)
    func deleteObject(key: String)
}
