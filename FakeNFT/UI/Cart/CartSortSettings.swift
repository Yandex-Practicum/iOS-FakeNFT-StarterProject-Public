//
//  CartSortSettings.swift
//  FakeNFT
//
//  Created by Сергей Петров on 26.07.2026.
//
import Foundation

// MARK: - CartSortType
enum CartSortType: String, CaseIterable, Identifiable {

    case price = "price"
    case rating = "rating"
    case name = "name"
    
    var id: String { self.rawValue }
    
    var localizedTitle: String {
        switch self {
        case .price:
            return NSLocalizedString("По цене", comment: "Сортировка по цене")
        case .rating:
            return NSLocalizedString("По рейтингу", comment: "Сортировка по рейтингу")
        case .name:
            return NSLocalizedString("По имени", comment: "Сортировка по имени")
        }
    }
}

// MARK: - CartSortStorage
final class CartSortStorage {
    static let shared = CartSortStorage()
    
    private let defaults = UserDefaults.standard
    private let sortKey = "selectedCartSortType"
    
    private init() {}
    
    var selectedSort: CartSortType {
        get {
            let rawValue = defaults.string(forKey: sortKey) ?? CartSortType.name.rawValue
            return CartSortType(rawValue: rawValue) ?? .name
        }
        set {
            defaults.set(newValue.rawValue, forKey: sortKey)
            defaults.synchronize()
        }
    }
}
