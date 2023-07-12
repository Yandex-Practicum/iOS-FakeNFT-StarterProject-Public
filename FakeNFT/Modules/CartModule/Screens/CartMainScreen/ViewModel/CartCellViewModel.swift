//
//  CartCellViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 21.06.2023.
//

import Foundation
import Combine

final class CartCellViewModel: ObservableObject {
    
    @Published private (set) var cartRow: SingleNft
    
    init(cartRow: SingleNft) {
        self.cartRow = cartRow
    }
    
    func createUrl(from stringUrl: String?) -> URL? {
        guard let stringUrl,
              let encodedStringUrl = stringUrl.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed)
        else { return nil }
        
        return URL(string: encodedStringUrl)
    }
}
