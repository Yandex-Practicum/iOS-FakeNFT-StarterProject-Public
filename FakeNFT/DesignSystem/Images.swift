//
//  Images.swift
//  FakeNFT
//
//  Created by Дмитрий on 05.09.2024.
//

import UIKit

enum Images {
    enum TabBar {
        static func icon(for tab: Tabs) -> UIImage? {
            switch tab {
            case .profile: return R.image.profile()
            case .cart: return R.image.cart()
            case .catalog: return R.image.catalog()
            case .statistic: return R.image.statistics()
            }
        }
    }
    enum Common {
        static let favoriteInactive = R.image.favoriteInactive()
        static let favoriteActive = R.image.favoriteActive()
        static let startInactive = R.image.starInactive()
        static let starActive = R.image.starActive()
        static let addCart = R.image.addCartBtn()
        static let deleteCartBtn = R.image.deleteCartBtn()
        static let addCartBtn = R.image.addCartBtn()
        static let sortBtn = R.image.sortBtn()
        static let closeBtn = R.image.sortBtn()
        static let backBtn = R.image.backward()
        static let forwardBtn = UIImage(systemName: "chevron.right")
    }
}
