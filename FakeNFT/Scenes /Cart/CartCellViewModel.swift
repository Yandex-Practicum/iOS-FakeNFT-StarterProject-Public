//
//  CartCellViewModel.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 25/06/2024.
//

import Combine
import Foundation

final class CartCellViewModel: ObservableObject {
    @Published var name: String
    @Published var price: String
    @Published var rating: Int
    @Published var imageName: String
    
    init(nft: Nft) {
        self.name = nft.name
        self.price = "\(nft.price) ETH"
        self.rating = nft.rating
        self.imageName = nft.images.first?.absoluteString ?? ""
    }
}
