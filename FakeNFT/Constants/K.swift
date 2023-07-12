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
        static let addItemToCart = "bag.badge.plus"
        static let activeStarRate = "activeStar"
        static let notActiveStarRate = "notActiveStar"
        static let chevronBackward = "chevron.backward"
        static let checkmark = "checkmark"
        static let xmark = "xmark"
        static let circleDotted = "circle.dotted"
        static let heart = "heart"
    }
    
    struct Titles {
        static let profileTitle = NSLocalizedString("Профиль", comment: "")
        static let catalogTitle = NSLocalizedString("Каталог", comment: "")
        static let cartTitle = NSLocalizedString("Корзина", comment: "")
        static let statisticsTitle = NSLocalizedString("Статистика", comment: "")
        static let paymentMethodScreenTitle = NSLocalizedString("Выберите способ оплаты", comment: "")
    }
    
    struct AlertTitles {
        static let sortAlertTitle = NSLocalizedString("Сортировка", comment: "")
        static let loadingAlertTitle = NSLocalizedString("Ошибка загрузки", comment: "")
    }
    
    struct Links {
        static let userLicenseLink = "https://yandex.ru/legal/practicum_termsofuse/"
        static let apiLink = "https://648cbbbe8620b8bae7ed5043.mockapi.io/"
    }
    
    struct EndPoints {
        static let currencies = "api/v1/currencies"
        static let orders = "api/v1/orders/1"
        static let collection = "api/v1/collections"
        static let singleCollection = "api/v1/nft/"
        static let pay = "api/v1/orders/1/payment/"
        static let author = "/api/v1/users/"
    }
}
