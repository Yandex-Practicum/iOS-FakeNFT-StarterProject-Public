//
//  TextLabels.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 01.03.2024.
//

import Foundation

struct TextLabels {
    struct TabBarController {
        static let profileTabBarTitle = "Профиль"
        static let catalogTabBarTitle = "Каталог"
        static let cartTabBarTitle = "Корзина"
        static let statisticTabBarTitle = "Статистика"
    }
    
    struct StatisticsVC {
        static let sortingTitle = "Cортировка"
        static let sortByNameTitle = "По имени"
        static let sortByRatingTitle = "По рейтингу"
        static let closeTitle = "Закрыть"
    }
    
    struct UserCardVC {
        static let userWebsiteButtonTitle = "Перейти на сайт пользователя"
        static let userCollectionsButtonTitle = "Коллекция NFT"
    }
    
    struct UsersCollectionVC {
        static let headerTitle = "Коллекция NFT"
    }
    
    struct CartViewController {
        static let toPaymentButton = "К оплате"
        static let deleteFromCartTitle = "Вы уверены, что хотите удалить объект из корзины?"
        static let deleteButton = "Удалить"
        static let returnButton = "Вернуться"
        static let emptyCartLabel = "Корзина пуста"
        static let alertTitle = "Cортировка"
        static let alertMessage = "Выберите сортировку"
        static let sortByName = "По названию"
        static let sortByRating = "По рейтингу"
        static let sortByPrice = "По цене"
        static let closeSorting = "Закрыть"
    }
    
    struct CartNFTCell {
        static let priceDescription = "Цена"
    }
    
    struct PaymentViewController {
        static let navigationTitle = "Выберите способ оплаты"
        static let payButtonTitle = "Оплатить"
        static let payDescription = "Совершая покупку, вы соглашаетесь с условиями"
        static let userAgreementTitle = "Пользовательского соглашения"
    }
    
    struct PaymentConfirmationViewController {
        static let paymentConfirmed = "Успех! Оплата прошла, поздравляем с покупкой!"
        static let paymentFailed = "Упс! Что-то пошло не так 🙁 Попробуйте еще раз!"
        static let returnButton = "Вернуться в каталог"
        static let tryAgainButton = "Попробовать еще раз"
    }
    
    struct CatalogVC {
        static let sorting = "Cортировка"
        static let sortByName = "По названию"
        static let sortByNFTCount = "По количеству NFT"
        static let close = "Закрыть"
    }
    
    struct CollectionVC {
        static let aboutAuthor = "Автор коллекции:"
    }
}
