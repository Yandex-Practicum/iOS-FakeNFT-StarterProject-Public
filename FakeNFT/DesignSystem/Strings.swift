//
//  Strings.swift
//  FakeNFT
//
//  Created by Дмитрий on 05.09.2024.
//

import Foundation

enum Strings {
    
    enum TabBar {
        static func title(for tab: Tabs) -> String {
            switch tab {
            case .catalog: return "Каталог"
            case .cart: return "Корзина"
            case .profile: return "Профиль"
            case .statistic: return "Статистика"
            }
        }
    }
    
    enum Alerts {
        static let sortByTitle = "По названию"
        static let sortByNftQuantity = "По количеству NFT"
        static let sortByPrice = "По цене"
        static let sortByRating = "По рейтингу"
        static let sortByName = "По имени"
        static let closeBtn = "Закрыть"
        static let cancleBtn = "Отменить"
        static let sortTitle = "Сортировка"
    }
}
