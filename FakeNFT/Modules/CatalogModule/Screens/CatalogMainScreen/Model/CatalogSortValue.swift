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
            return NSLocalizedString("По названию", comment: "")
        case .cancel:
            return NSLocalizedString("Закрыть", comment: "")
        case .quantity:
            return NSLocalizedString("По количеству NFT", comment: "")
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
