//
//  SettingsStorage.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 08.09.2023.
//

import Foundation

protocol SettingsStorageProtocol {
    func saveSorting(_ descriptor: SortDescriptor)
    func fetchSorting() -> SortDescriptor?
}

final class SettingsStorage: SettingsStorageProtocol {

    // MARK: - Properties
    private let storage = UserDefaults.standard
    private let sortingKey = "sortingKey"

    // MARK: - Methods
    func saveSorting(_ descriptor: SortDescriptor) {
        storage.set(descriptor.rawValue, forKey: sortingKey)
    }

    func fetchSorting() -> SortDescriptor? {
        if let sortDescriptorRawValue = storage.object(forKey: sortingKey) as? String {
            if let sortDescriptor = SortDescriptor(rawValue: sortDescriptorRawValue) {
                return sortDescriptor
            }
        }
        return nil
    }
}

enum SortDescriptor: String {
    case price
    case name
    case rating
}
