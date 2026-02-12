//
//  Sorting.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 28.01.2026.
//

import Foundation

enum Sorting {
    case price
    case rating
    case name
    
    var title: String {
        switch self {
        case .price: return "По цене"
        case .rating: return "По рейтингу"
        case .name: return "По названию"
        }
    }
}
