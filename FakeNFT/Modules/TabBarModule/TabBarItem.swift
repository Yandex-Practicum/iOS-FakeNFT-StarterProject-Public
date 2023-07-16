//
//  TabBarItem.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

enum MainTabBarItem: String {
    case profile
    case catalog
    case cart
    case statistics
    
    var tabImage: UIImage? {
        switch self {
        case .profile:
            return UIImage(systemName: K.Icons.profileIcon)
        case .catalog:
            return UIImage(systemName: K.Icons.catalogIcon)
        case .cart:
            return UIImage(systemName: K.Icons.cartIcon)
        case .statistics:
            return UIImage(systemName: K.Icons.statistics)
        }
    }
    
    var title: String {
        switch self {
        case .profile:
            return K.Titles.profileTitle
        case .catalog:
            return K.Titles.catalogTitle
        case .cart:
            return K.Titles.cartTitle
        case .statistics:
            return K.Titles.statisticsTitle
        }
    }
}
