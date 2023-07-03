//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 03.07.2023.
//

import Foundation
import Combine

final class CatalogCollectionViewModel {
    @Published private (set) var nftCollection: NftCollection
    
    init(nftCollection: NftCollection) {
        self.nftCollection = nftCollection
    }
}
