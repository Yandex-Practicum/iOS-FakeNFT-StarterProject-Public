//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import Foundation
import Combine

protocol CatalogViewModelProtocol: AnyObject {
    var catalog: [Catalog] { get set }
    var catalogPublisher: Published<Array<Catalog>>.Publisher { get }
    func sortCatalogByName()
    func sortCatalogByQuantity()
}

final class CatalogViewModel: CatalogViewModelProtocol {
    @Published var catalog: [Catalog] = []
    var catalogPublisher: Published<Array<Catalog>>.Publisher { $catalog }
    private var catalogService: CatalogServiceProtocol
    private var subscribes = [AnyCancellable]()
    
    init(catalogService: CatalogServiceProtocol) {
        self.catalogService = catalogService
//        self.catalogService.catalogVM = self
        self.catalogService.fetchCatalog()
        catalog = catalogService.catalog
        subscribe()
    }
    
    func sortCatalogByName() {
        catalog.sort { $0.name < $1.name }
    }
    
    func sortCatalogByQuantity() {
        catalog.sort { $0.nfts.count > $1.nfts.count }
    }
    
    private func subscribe() {
        catalogService.catalogServicePublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                catalog = catalogService.catalog
                
            }.store(in: &subscribes)
    }
}
