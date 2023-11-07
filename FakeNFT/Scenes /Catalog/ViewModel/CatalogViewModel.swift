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
    func sortCatalog()
}

final class CatalogViewModel: CatalogViewModelProtocol {
    @Published var catalog: [Catalog] = []
    var catalogPublisher: Published<Array<Catalog>>.Publisher { $catalog }
    private var filter: CatalogFilter?
    private var catalogService: CatalogServiceProtocol
    private var subscribes = [AnyCancellable]()
    
    init(catalogService: CatalogServiceProtocol) {
        self.catalogService = catalogService
        self.catalogService.fetchCatalog()
        catalog = catalogService.catalog
        subscribe()
        self.filter = CatalogFilter(rawValue: CatalogFilterStorage.shared.filterDescriptor ?? "name")
        sortCatalog()
    }
    
    func sortCatalog() {
        switch filter {
        case .name:
            sortCatalogByName()
        case .quantity:
            sortCatalogByQuantity()
        default:
            sortCatalogByName()
        }
    }
    
    func sortCatalogByName() {
        catalog.sort { $0.name < $1.name }
        CatalogFilterStorage.shared.filterDescriptor = CatalogFilter.name.rawValue
    }
    
    func sortCatalogByQuantity() {
        catalog.sort { $0.nfts.count > $1.nfts.count }
        CatalogFilterStorage.shared.filterDescriptor = CatalogFilter.quantity.rawValue
    }
    
    private func subscribe() {
        catalogService.catalogServicePublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                catalog = catalogService.catalog
                sortCatalog()
            }.store(in: &subscribes)
    }
}
