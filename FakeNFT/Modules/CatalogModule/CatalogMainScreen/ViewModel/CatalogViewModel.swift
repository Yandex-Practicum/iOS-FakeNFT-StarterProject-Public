//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 02.07.2023.
//

import Foundation

final class CatalogViewModel {
    
    @Published private (set) var visibleRows: [NftCollections] = []
    @Published private (set) var catalogError: Error?
    @Published private (set) var requestResult: RequestResult?
    
}
