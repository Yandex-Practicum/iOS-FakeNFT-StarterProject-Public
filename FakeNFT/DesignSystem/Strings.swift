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
        static let sortByTitle = R.string.localizable.alertSortByTitle()
        static let sortByNftQuantity = R.string.localizable.alertSortByNftQuantity()
        static let sortByPrice = R.string.localizable.alertSortByPrice()
        static let sortByRating = R.string.localizable.alertSortByRating()
        static let sortByName = R.string.localizable.alertSortByName()
        static let closeBtn = R.string.localizable.alertCloseBtn()
        static let cancleBtn = R.string.localizable.alertCancleBtn()
        static let sortTitle = R.string.localizable.alertSortTitle()
    }
    
    enum Common {
        static let price = R.string.localizable.commonPrice()
        static let eth = R.string.localizable.commonETH()
    }
    
    enum Catalog {
        static let openNft = R.string.localizable.catalogOpenNft()
        static let collectionAuthor = R.string.localizable.catalogCollectionAuthor()
        static let addToCart = R.string.localizable.catalogAddToCart()
        static let toSalerSite = R.string.localizable.catalogToSalerSite()
    }
    
    enum Cart {
        static let toPay = R.string.localizable.cartToPay()
        static let deleteMessage = R.string.localizable.cartDeleteMessage()
        static let deleteBrn = R.string.localizable.cartDeleteBrn()
        static let backBtn = R.string.localizable.cartBackBtn()
        static let navTitle = R.string.localizable.cartNavTitle()
        static let userAgreementMsg = R.string.localizable.cartUserAgreementMsg()
        static let userAgreement = R.string.localizable.cartUserAgreement()
        static let payBtn = R.string.localizable.cartPayBtn()
        static let successMsg = R.string.localizable.cartSuccessMsg()
        static let backToCartBtn = R.string.localizable.cartBackToCartBtn()
        static let errorMsg = R.string.localizable.cartErrorMsg()
        static let cancleBtn = R.string.localizable.commonCancleBtn()
        static let repeatBtn = R.string.localizable.commonRepeatBtn()
        static let emptyMsg = R.string.localizable.cartEmptyMsg()
    }
    
    enum Profile {
        static let myNft = R.string.localizable.profileMyNft()
        static let favoritesNft = R.string.localizable.profileFavoritesNft()
        static let aboutAuthor = R.string.localizable.profileAboutAuthor()
        static let name = R.string.localizable.profileName()
        static let description = R.string.localizable.profileDescription()
        static let site = R.string.localizable.profileSite()
        static let changePhoto = R.string.localizable.profileChangePhoto()
        static let loadPhoto = R.string.localizable.profileLoadPhoto()
        static let emptyNft = R.string.localizable.profileEmptyNft()
        static let emptyFavoritesNft = R.string.localizable.profileEmptyFaforitesNft()
    }
    
    enum Statistics {
        static let toAuthorSite = R.string.localizable.statisticsToAuthorSite()
        static let collectionNft = R.string.localizable.statisticsCollectionNft()
    }
    
    enum Error {
        static let network = R.string.localizable.errorNetwork()
        static let unknown = R.string.localizable.errorUnknown()
        static let repeatMsg = R.string.localizable.errorRepeat()
        static let title = R.string.localizable.errorTitle()
    }
}
