//
//  CatalogAssembly.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 08.11.2023.
//

import Foundation

final class CatalogAssembly {

    private init() {}

    static func buildCatalogViewModel() -> CatalogViewModelProtocol {
        let network = DefaultNetworkClient()
        let service = CatalogService(networkClient: network)
        let viewModel = CatalogViewModel(catalogService: service)
        return viewModel
    }

    static func buildCatalogCollectionViewModel(catalog: Catalog) -> CatalogCollectionViewModelProtocol {
        let network = DefaultNetworkClient()
        let service = NftServiceImpl(networkClient: network, storage: NftStorageImpl())
        let viewModel = CatalogCollectionViewModel(catalogCollection: catalog, service: service)
        return viewModel
    }
}
