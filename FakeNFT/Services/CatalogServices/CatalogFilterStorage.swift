//
//  CatalogFilterStorage.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import Foundation

final class CatalogFilterStorage {

    // MARK: - public properties
    static let shared = CatalogFilterStorage()
    var filterDescriptor: String? {
        get {
            userDefaults.string(forKey: L10n.CatalogFilterStorage.key)
        }
        set {
            if let newValue = newValue {
                userDefaults.set(newValue, forKey: L10n.CatalogFilterStorage.key)
            }
        }
    }

    // MARK: - private properties
    private var userDefaults = UserDefaults.standard

    private init() {}
}

enum CatalogFilter: String {
    case filterName = "name"
    case filterQuantity = "quantity"
}
