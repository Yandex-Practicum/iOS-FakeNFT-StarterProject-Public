//
//  CatalogCollectionCellViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 04.07.2023.
//

import Foundation
import Combine

final class CatalogCollectionCellViewModel: ObservableObject {
    @Published private (set) var nftRow: VisibleSingleNfts
    
    init(nftRow: VisibleSingleNfts) {
        self.nftRow = nftRow
    }
    
    func updateIsLiked() {
        let newRow = VisibleSingleNfts(
            name: nftRow.name,
            images: nftRow.images,
            rating: nftRow.rating,
            description: nftRow.description,
            price: nftRow.price,
            author: nftRow.author,
            id: nftRow.id,
            isStored: nftRow.isStored,
            isLiked: !nftRow.isLiked)
        
        self.nftRow = newRow
    }
    
    func updateIsStored() {
        let newRow = VisibleSingleNfts(
            name: nftRow.name,
            images: nftRow.images,
            rating: nftRow.rating,
            description: nftRow.description,
            price: nftRow.price,
            author: nftRow.author,
            id: nftRow.id,
            isStored: !nftRow.isStored,
            isLiked: nftRow.isLiked)
        print("isStored updated")
        self.nftRow = newRow
    }
}
