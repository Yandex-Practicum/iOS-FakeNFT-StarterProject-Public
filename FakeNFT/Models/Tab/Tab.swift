//
//  Tab.swift
//  FakeNFT
//
//  Created by Anastasia on 25.05.2025.
//

import Foundation

enum Tab: String, CaseIterable {
    case profile
    case catalog
    case cart
    case statistics
    
    var title: String {
        switch self {
        case .profile:
            return "Профиль"
        case .catalog:
            return "Каталог"
        case .cart:
            return "Корзина"
        case .statistics:
            return "Статистика"
        }
    }
    
    var imageName: String {
        switch self {
        case .profile:
            return "profile"
        case .catalog:
            return "catalog"
        case .cart:
            return "cart"
        case .statistics:
            return "statistics"
        }
    }
}
