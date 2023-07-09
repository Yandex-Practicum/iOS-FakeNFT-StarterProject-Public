//
//  CommonCollectionDataSourceItem.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 09.07.2023.
//

import Foundation

enum CommonCollectionDataSourceItem: Hashable {
    case paymentMethod(PaymentMethodRow)
    case visibleNft(VisibleSingleNfts)
    
    static func ==(lhs: CommonCollectionDataSourceItem, rhs: CommonCollectionDataSourceItem) -> Bool {
        switch (lhs, rhs) {
        case let (.paymentMethod(item1), .paymentMethod(item2)):
            return item1 == item2
        case let (.visibleNft(item1), .visibleNft(item2)):
            return item1 == item2
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .paymentMethod(item):
            hasher.combine(item)
        case let .visibleNft(item):
            hasher.combine(item)
        }
    }
}
