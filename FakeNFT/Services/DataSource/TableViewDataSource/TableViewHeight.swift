//
//  TableViewHeight.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 09.07.2023.
//

import Foundation

enum TableViewHeight {
    case catalog, cart, profile, profileMyNft
    
    var height: CGFloat {
        switch self {
        case .catalog:
            return 3.0
        case .cart:
            return 4.0
        case .profile:
            return 7.0
        case .profileMyNft:
            return 4.0
        }
    }
}
