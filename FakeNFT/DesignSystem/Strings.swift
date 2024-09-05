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
            case .catalog: return R.string.localizable.tabCatalog()
            case .cart: return R.string.localizable.tabCart()
            case .profile: return R.string.localizable.tabProfile()
            case .statistic: return R.string.localizable.tabStatistics()
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
