//
//  CatalogFilterStorage.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import Foundation

final class CatalogFilterStorage {
    static let shared = CatalogFilterStorage()
    var filterDescriptor: String? {
        get {
            userDefaults.string(forKey: Constants.filterKey)
        }
        set {
            if let newValue = newValue {
                userDefaults.set(newValue, forKey: Constants.filterKey)
            }
        }
    }
    
    private var userDefaults = UserDefaults.standard
    
    private init() {}
}

enum CatalogFilter: String {
    case name = "name"
    case quantity = "quantity"
}
