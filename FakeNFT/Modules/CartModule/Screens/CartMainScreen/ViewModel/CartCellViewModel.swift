//
//  CartCellViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 21.06.2023.
//

import Foundation
import Combine

final class CartCellViewModel: ObservableObject {
    
    @Published private (set) var cartRow: NftSingleCollection
    
    init(cartRow: NftSingleCollection) {
        self.cartRow = cartRow
    }
}
