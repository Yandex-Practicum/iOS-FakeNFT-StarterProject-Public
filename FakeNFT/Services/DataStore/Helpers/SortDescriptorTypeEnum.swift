//
//  SortDescriptorTypeEnum.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 01.08.2023.
//

import Foundation

enum SortDescriptorType {
    case priceRatingName(NftSortValue)
    case nameQuantity(CollectionSortValue)
}
