//
//  CatalogSortValue.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 02.07.2023.
//

import UIKit

enum CatalogSortValue: CaseIterable, Sortable {
    case name, quantity, cancel
    
    var description: String {
        switch self {
        case .name:
            return K.AlertTitles.nameSort
        case .cancel:
            return K.AlertTitles.cancel
        case .quantity:
            return K.AlertTitles.dependingOnQuantity
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .name, .quantity:
            return .default
        case .cancel:
            return .cancel
        }
    }
}
