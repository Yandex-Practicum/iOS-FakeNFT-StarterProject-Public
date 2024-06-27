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
    @Published var isLoading: Bool = false
    
    // MARK: - Initialization
    
    init() {
        loadMockData()
    }
    
    // MARK: - Data Loading
    
    private func loadMockData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.nftsInCart = MockData.createMockNFTs()
            self?.updateTotalItems()
            self?.updateTotalPrice()
            self?.isLoading = false
            self?.objectWillChange.send()
        }
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
