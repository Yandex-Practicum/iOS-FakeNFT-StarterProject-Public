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
        static let placeholder = "placeholder"
        static let activeLike = "activeLike"
        static let notActiveLike = "notActiveLike"
        static let addToCart = "addToCart"
        static let deleteFromCart = "deleteFromCart"
    }
    
    struct Titles {
        static let profileTitle = NSLocalizedString("Профиль", comment: "")
        static let catalogTitle = NSLocalizedString("Каталог", comment: "")
        static let cartTitle = NSLocalizedString("Корзина", comment: "")
        static let statisticsTitle = NSLocalizedString("Статистика", comment: "")
        static let paymentMethodScreenTitle = NSLocalizedString("Выберите способ оплаты", comment: "")
        static let emailTextFieldTitle = NSLocalizedString("Email", comment: "")
        static let passwordTextFieldTitle = NSLocalizedString("Пароль", comment: "")
        static let loginButtonTitle = NSLocalizedString("Войти", comment: "")
        static let demoButtonTitle = NSLocalizedString("Демо", comment: "")
        static let registerButtonTitle = NSLocalizedString("Зарегистрироваться", comment: "")
        static let forgotPasswordButtonTitle = NSLocalizedString("Забыли пароль?", comment: "")
        static let loginLabelEnterTitle = NSLocalizedString("Вход", comment: "")
        static let loginLabelChangePasswordTitle = NSLocalizedString("Сброс пароля", comment: "")
        static let onboardingProceedButtonTitle = NSLocalizedString("Что внутри?", comment: "")
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
    
    struct KeyChainServices {
        static let profileLogin = "profile.login"
    }
    
    struct LogInErrors {
        static let invalidData = NSLocalizedString("Введен неверный логин или пароль", comment: "")
        static let userExists = NSLocalizedString("Пользователь с таким адресом уже зарегистрирован", comment: "")
        static let textFieldEmpty = NSLocalizedString("Одно из полей не заполнено", comment: "")
        static let internalError = NSLocalizedString("Внутренняя ошибка, попробуйте позже", comment: "")
    }
    
    struct PasswordResetMessages {
        static let passwordResetSuccess = NSLocalizedString("Инструкции по восстановлению пароля высланы на указанный email", comment: "")
        static let passwordResetFailure = NSLocalizedString("Пользователь не найден", comment: "")
    }
    
    struct Spacing {
        static let loginBaseSpacingCoefficient = 0.075
    }
    
    struct Onboarding {
        struct Titles {
            static let discoverOnboardingPageTitle = NSLocalizedString("Исследуйте", comment: "")
            static let collectOnboardingPageTitle = NSLocalizedString("Коллекционируйте", comment: "")
            static let competeOnboardingPageTitle = NSLocalizedString("Состязайтесь", comment: "")
        }
        
        struct Descriptions {
            static let discoverOnboardingPageDescription = NSLocalizedString("Присоединяйтесь и откройте новый мир уникальных NFT для коллекционеров", comment: "")
            static let collectOnboardingPageDescription = NSLocalizedString("Пополняйте свою коллекцию эксклюзивными картинками, созданными нейросетью!", comment: "")
            static let competeOnboardingPageDescription = NSLocalizedString("Смотрите статистику других и покажите всем, что у вас самая ценная коллекция", comment: "")
        }
        
        struct Background {
            static let onboarding1 = "onboarding1"
            static let onboarding2 = "onboarding2"
            static let onboarding3 = "onboarding3"
        }
        
        
    }
}
