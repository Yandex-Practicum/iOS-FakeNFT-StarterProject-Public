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
            case .profile: return UIImage(named: "profile")
            case .cart: return UIImage(named: "cart")
            case .catalog: return UIImage(named: "catalog")
            case .statistic: return UIImage(named: "statistics")
            }
        }
    }
}
