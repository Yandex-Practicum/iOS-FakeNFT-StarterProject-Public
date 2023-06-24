//
//  CartSortValue.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 20.06.2023.
//

import UIKit

enum CartSortValue: CaseIterable {
    case price, rating, name, cancel
    
    var description: String {
        switch self {
        case .price:
            return NSLocalizedString("По цене", comment: "")
        case .rating:
            return NSLocalizedString("По рейтингу", comment: "")
        case .name:
            return NSLocalizedString("По названию", comment: "")
        case .cancel:
            return NSLocalizedString("Закрыть", comment: "")
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .price:
            return .default
        case .rating:
            return .default
        case .name:
            return .default
        case .cancel:
            return .cancel
        }
    }
}
