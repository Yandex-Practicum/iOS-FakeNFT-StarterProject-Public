//
//  CartCellViewModel.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 25/06/2024.
//

import Combine
import Foundation

// MARK: - CartViewData

struct CartViewData {
    let name: String
    let price: String
    let rating: Int
    let imageURLString: String
}

// MARK: - CartCellViewModel

final class CartCellViewModel: ObservableObject {
    @Published var viewData: CartViewData
    
    let nft: Nft
    
    init(nft: Nft) {
        self.nft = nft
        self.viewData = CartViewData(
            name: nft.name,
            price: "\(nft.price) ETH",
            rating: nft.rating,
            imageURLString: nft.images.first?.absoluteString ?? ""
        )
    }
}
