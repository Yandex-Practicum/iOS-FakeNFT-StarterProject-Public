//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 25/06/2024.
//

import Combine
import Foundation

final class CartViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var nftsInCart: [Nft] = []
    @Published var totalItems: String = "0 NFT"
    @Published var totalPrice: String = "0 ETH"
    
    // MARK: - Initialization
    
    init() {
        loadMockData()
    }
    
    // MARK: - Data Loading
    
    private func loadMockData() {
        nftsInCart = MockData.createMockNFTs()
        updateTotalItems()
        updateTotalPrice()
    }
    
    // MARK: - Update Methods
    
    private func updateTotalItems() {
        totalItems = "\(nftsInCart.count) NFT"
    }
    
    private func updateTotalPrice() {
        let totalPriceValue = nftsInCart.reduce(0) { $0 + $1.price }
        totalPrice = String(format: "%.2f ETH", totalPriceValue)
    }
}
