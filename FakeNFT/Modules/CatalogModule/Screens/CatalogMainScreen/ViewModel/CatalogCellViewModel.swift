//
//  CatalogCellViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 02.07.2023.
//

import Foundation
import Combine

final class CatalogCellViewModel: ObservableObject {
    @Published private (set) var catalogRows: NftCollection
    
    init(catalogRows: NftCollection) {
        self.catalogRows = catalogRows
    }
}
