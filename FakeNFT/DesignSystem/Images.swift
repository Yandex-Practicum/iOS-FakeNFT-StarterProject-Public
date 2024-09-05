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
}
