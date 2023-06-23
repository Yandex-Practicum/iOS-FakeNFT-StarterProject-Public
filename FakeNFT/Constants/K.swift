//
//  K.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

struct K {
    struct Icons {
        static let profileIcon = "person.crop.circle.fill"
        static let catalogIcon = "person.crop.rectangle.stack.fill"
        static let cartIcon = "bag.fill"
        static let statistics = "flag.2.crossed.fill"
        static let filterRightBarButtonIcon = "line.3.horizontal.decrease"
        static let deleteItemFromCart = "bag.badge.minus"
        static let activeStarRate = "activeStar"
        static let notActiveStarRate = "notActiveStar"
        static let chevronBackward = "chevron.backward"
    }
    
    struct Titles {
        static let profileTitle = NSLocalizedString("Профиль", comment: "")
        static let catalogTitle = NSLocalizedString("Каталог", comment: "")
        static let cartTitle = NSLocalizedString("Корзина", comment: "")
        static let statisticsTitle = NSLocalizedString("Статистика", comment: "")
    }
    
    struct Links {
        static let userLicenseLink = "https://yandex.ru/legal/practicum_termsofuse/"
    }
}
