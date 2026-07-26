//
//  CartSortSettings.swift
//  FakeNFT
//
//  Created by Сергей Петров on 26.07.2026.
//

import Foundation
import Observation

// MARK: - CartSortType
enum CartSortType: String, CaseIterable, Identifiable {

    case price = "By price"
    case rating = "By rating"
    case name = "By name"
    
    var id: String { self.rawValue }
    
    var localizedTitle: String {
        switch self {
        case .price:
            return NSLocalizedString("По цене", comment: "Сортировка по цене")
        case .rating:
            return NSLocalizedString("По рейтингу", comment: "Сортировка по рейтингу")
        case .name:
            return NSLocalizedString("По названию", comment: "Сортировка по имени")
        }
    }
}

// MARK: - CartSortStorage
@Observable
final class CartSortStorage {
    
    // MARK: - Properties
    private let defaults = UserDefaults.standard
    
    // MARK: - Computed Property
    var selectedSort: CartSortType {
        get {
            let rawValue = defaults.string(forKey: Keys.selectedSortType) ?? CartSortType.name.rawValue
            return CartSortType(rawValue: rawValue) ?? .name
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.selectedSortType)
        }
    }
    
    // MARK: - Init
    init() {
        _ = selectedSort
    }
}

// MARK: - Private Keys
private extension CartSortStorage {
    enum Keys {
        static let selectedSortType = "selectedCartSortType"
    }
}
