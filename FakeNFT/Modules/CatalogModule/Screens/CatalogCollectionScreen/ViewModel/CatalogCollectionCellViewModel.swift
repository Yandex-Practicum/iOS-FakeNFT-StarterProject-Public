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
    
    func createUrl(from stringUrl: String?) -> URL? {
        guard let stringUrl,
              let encodedStringUrl = stringUrl.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed)
        else { return nil }
        
        return URL(string: encodedStringUrl)
    }
}
