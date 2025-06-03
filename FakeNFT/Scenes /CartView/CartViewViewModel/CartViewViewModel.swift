//
//  CartViewViewModel.swift
//  FakeNFT
//
//  Created by Max on 28.05.2025.
//

import Foundation


final class CartViewViewModel: ObservableObject {
    @Published var cartItems = [Nft.mock]
    @Published var currency = Currency.mock
    @Published var totalAmount: Double = 5.38
    @Published var nftCount: Int = 3
    
    func loadCart() {
        cartItems = [
              Nft.mock,
              Nft.mock,
              Nft.mock
          ]
    }
}
