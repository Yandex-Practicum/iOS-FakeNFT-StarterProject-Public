//
//  CartSortValue.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 20.06.2023.
//

import UIKit

enum CartSortValue: CaseIterable, Sortable {
    case price, rating, name, cancel
    
    var description: String {
        switch self {
        case .price:
            return K.AlertTitles.dependingOnPrice
        case .rating:
            return K.AlertTitles.dependingOnRate
        case .name:
            return K.AlertTitles.dependingOnName
        case .cancel:
            return K.AlertTitles.cancel
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .price, .rating, .name:
            return .default
        case .cancel:
            return .cancel
        }
    }
}
