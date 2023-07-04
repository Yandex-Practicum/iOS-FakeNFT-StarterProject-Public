//
//  CatalogCollectionCellViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 04.07.2023.
//

import Foundation
import Combine

final class CatalogCollectionCellViewModel: ObservableObject {
    @Published private (set) var nftRow: SingleNft
    
    init(nftRow: SingleNft) {
        self.nftRow = nftRow
    }
}
