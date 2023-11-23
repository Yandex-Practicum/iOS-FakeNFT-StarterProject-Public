//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import Foundation
import Combine

final class CatalogViewModel: CatalogViewModelProtocol {

    // MARK: - Public properties
    @Published var isLoadingData: Bool = true
    @Published var catalog: [Catalog] = []
    @Published var networkError: Error?
    var catalogPublisher: Published<Array<Catalog>>.Publisher { $catalog }
    var loadingDataPublisher: Published<Bool>.Publisher { $isLoadingData }
    var errorPublisher: Published<Error?>.Publisher { $networkError }

    // MARK: - Private properties
    private var filter: CatalogFilter?
    private var catalogService: CatalogServiceProtocol
    private var subscribes = [AnyCancellable]()

    init(catalogService: CatalogServiceProtocol) {
        self.catalogService = catalogService

        fetchCatalog()
        fetchProfileLikes()
        fetchAddedToBasketNfts()

        self.filter = CatalogFilter(
            rawValue: CatalogFilterStorage.shared.filterDescriptor ?? CatalogFilter.filterQuantity.rawValue
        )
        sortCatalog()
    }

    // MARK: - Public methods
    func sortCatalog() {
        switch filter {
        case .filterName:
            sortCatalogByName()
        case .filterQuantity:
            sortCatalogByQuantity()
        default:
            sortCatalogByQuantity()
        }
    }

    func sortCatalogByName() {
        catalog.sort { $0.name < $1.name }
        CatalogFilterStorage.shared.filterDescriptor = CatalogFilter.filterName.rawValue
    }

    func sortCatalogByQuantity() {
        catalog.sort { $0.nfts.count > $1.nfts.count }
        CatalogFilterStorage.shared.filterDescriptor = CatalogFilter.filterQuantity.rawValue
    }

    // MARK: - Private mathods
    func fetchCatalog() {
        isLoadingData = true
        catalogService.fetchCatalog { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let catalogRes):
                isLoadingData = false
                catalog = catalogRes
                sortCatalog()
            case .failure(let error):
                isLoadingData = false
                networkError = error
            }
        }
    }

    // methods implemented for temporary use in catalog epic to handle likes and addToBasket interaction
    // when the full project is merged - these two methods will be removed
    // both methods should be implemented in Profile epic
    private func fetchProfileLikes() {
        catalogService.fetchProfileLikes { result in
            switch result {
            case .success(let profile):
                LikesStorage.shared.likes = profile.likes
            case .failure(let error):
                print(error)
            }
        }
    }

    private func fetchAddedToBasketNfts() {
        catalogService.fetchAddedToBasketNfts { result in
            switch result {
            case .success(let order):
                PurchaseCartStorage.shared.nfts = order.nfts
            case .failure(let error):
                print(error)
            }
        }
    }
}
