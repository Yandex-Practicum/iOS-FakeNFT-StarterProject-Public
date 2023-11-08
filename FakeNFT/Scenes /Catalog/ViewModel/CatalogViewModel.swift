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
    
    //MARK: - Public properties
    @Published var catalog: [Catalog] = []
    var catalogPublisher: Published<Array<Catalog>>.Publisher { $catalog }
    
    //MARK: - Private properties
    private var filter: CatalogFilter?
    private var catalogService: CatalogServiceProtocol
    private var subscribes = [AnyCancellable]()
    
    init(catalogService: CatalogServiceProtocol) {
        self.catalogService = catalogService
        
        subscribe()
        fetchCatalog()
        
        self.filter = CatalogFilter(rawValue: CatalogFilterStorage.shared.filterDescriptor ?? "name")
        sortCatalog()
    }
    
    //MARK: - Public methods
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
    
    //MARK: - Private mathods
    private func subscribe() {
        catalogService.catalogServicePublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] catalogUpdate in
                guard let self = self else { return }
                catalog = catalogUpdate
                sortCatalog()
            }.store(in: &subscribes)
    }
    
    private func fetchCatalog() {
        catalogService.fetchCatalog()
    }
}
