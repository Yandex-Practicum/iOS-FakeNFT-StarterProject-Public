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
        static let profileTitle = NSLocalizedString("profileTitle", comment: "")
        static let catalogTitle = NSLocalizedString("catalogTitle", comment: "")
        static let cartTitle = NSLocalizedString("cartTitle", comment: "")
        static let statisticsTitle = NSLocalizedString("statisticsTitle", comment: "")
        static let paymentMethodScreenTitle = NSLocalizedString("paymentMethodScreenTitle", comment: "")
        static let emailTextFieldTitle = NSLocalizedString("Email", comment: "")
        static let passwordTextFieldTitle = NSLocalizedString("passwordTextFieldTitle", comment: "")
        static let loginButtonTitle = NSLocalizedString("loginButtonTitle", comment: "")
        static let demoButtonTitle = NSLocalizedString("demoButtonTitle", comment: "")
        static let registerButtonTitle = NSLocalizedString("registerButtonTitle", comment: "")
        static let forgotPasswordButtonTitle = NSLocalizedString("forgotPasswordButtonTitle", comment: "")
        static let loginLabelEnterTitle = NSLocalizedString("loginLabelEnterTitle", comment: "")
        static let loginLabelChangePasswordTitle = NSLocalizedString("loginLabelChangePasswordTitle", comment: "")
        static let onboardingProceedButtonTitle = NSLocalizedString("onboardingProceedButtonTitle", comment: "")
        static let toPayment = NSLocalizedString("toPayment", comment: "")
        static let emptyCart = NSLocalizedString("emptyCart", comment: "")
        static let delete = NSLocalizedString("delete", comment: "")
        static let price = NSLocalizedString("price", comment: "")
        static let questionBeforeDelete = NSLocalizedString("questionBeforeDelete", comment: "")
        static let goBack = NSLocalizedString("goBack", comment: "")
        static let userLicenceLineOne = NSLocalizedString("userLicenceLineOne", comment: "")
        static let userLicenceLineTwo = NSLocalizedString("userLicenceLineTwo", comment: "")
        static let tryAgain = NSLocalizedString("tryAgain", comment: "")
        static let leaveAsItIs = NSLocalizedString("leaveAsItIs", comment: "")
        static let successfulPurchase = NSLocalizedString("successfulPurchase", comment: "")
        static let unSuccessfulPurchase = NSLocalizedString("unSuccessfulPurchase", comment: "")
        static let loadingData = NSLocalizedString("loadingData", comment: "")
        static let backToCatalog = NSLocalizedString("backToCatalog", comment: "")
        static let profileMyNfts = NSLocalizedString("profileMyNfts", comment: "")
        static let profileMyLikedNfts = NSLocalizedString("profileMyLikedNfts", comment: "")
        static let authorWebsite = NSLocalizedString("authorWebsite", comment: "")
        static let favouriteNfts = NSLocalizedString("favouriteNfts", comment: "")
    }
    
    struct AlertTitles {
        static let sortAlertTitle = NSLocalizedString("sortAlertTitle", comment: "")
        static let loadingAlertTitle = NSLocalizedString("loadingAlertTitle", comment: "")
        static let nameSort = NSLocalizedString("nameSort", comment: "")
        static let cancel = NSLocalizedString("cancel", comment: "")
        static let dependingOnQuantity = NSLocalizedString("dependingOnQuantity", comment: "")
        static let dependingOnPrice = NSLocalizedString("dependingOnPrice", comment: "")
        static let dependingOnRate = NSLocalizedString("dependingOnRate", comment: "")
        static let dependingOnName = NSLocalizedString("dependingOnName", comment: "")
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
        static let profile = "api/v1/profile/1"
        static let singleNft = "api/v1/nft/"
    }
    
    struct KeyChainServices {
        static let profileLogin = "profile.login"
    }
    
    struct LogInErrors {
        static let invalidData = NSLocalizedString("invalidData", comment: "")
        static let userExists = NSLocalizedString("userExists", comment: "")
        static let textFieldEmpty = NSLocalizedString("textFieldEmpty", comment: "")
        static let internalError = NSLocalizedString("internalError", comment: "")
    }
    
    struct PasswordResetMessages {
        static let passwordResetSuccess = NSLocalizedString("passwordResetSuccess", comment: "")
        static let passwordResetFailure = NSLocalizedString("passwordResetFailure", comment: "")
    }
    
    struct Spacing {
        static let loginBaseSpacingCoefficient = 0.075
    }
    
    struct Onboarding {
        struct Titles {
            static let discoverOnboardingPageTitle = NSLocalizedString("discoverOnboardingPageTitle", comment: "")
            static let collectOnboardingPageTitle = NSLocalizedString("collectOnboardingPageTitle", comment: "")
            static let competeOnboardingPageTitle = NSLocalizedString("competeOnboardingPageTitle", comment: "")
        }
        
        struct Descriptions {
            static let discoverOnboardingPageDescription = NSLocalizedString("discoverOnboardingPageDescription", comment: "")
            static let collectOnboardingPageDescription = NSLocalizedString("collectOnboardingPageDescription", comment: "")
            static let competeOnboardingPageDescription = NSLocalizedString("competeOnboardingPageDescription", comment: "")
        }
        
        struct Background {
            static let onboarding1 = "onboarding1"
            static let onboarding2 = "onboarding2"
            static let onboarding3 = "onboarding3"
        }
        
        
    }
}
