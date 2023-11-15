//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import Foundation
import Combine

protocol CatalogCollectionViewModelProtocol: AnyObject {
    var nftsLoadingIsCompleted: Bool { get }
    var nftsLoaderPuublisher: Published<Bool>.Publisher { get }
    var nfts: [NftModel] { get }
    var catalogCollection: Catalog { get }
    var author: Author? { get }
    var authorPublisher: Published<Author?>.Publisher { get }
    func calculateCollectionViewHeight() -> CGFloat
}

final class CatalogCollectionViewModel: CatalogCollectionViewModelProtocol {

    @Published var nftsLoadingIsCompleted: Bool = false
    @Published var author: Author?
    var nftsLoaderPuublisher: Published<Bool>.Publisher { $nftsLoadingIsCompleted }
    var authorPublisher: Published<Author?>.Publisher { $author }
    var nfts: [NftModel] = []
    var catalogCollection: Catalog
    var networkError: Error?

    private let collectionService: CatalogCollectionService

    init(catalogCollection: Catalog, service: CatalogCollectionService) {
        self.catalogCollection = catalogCollection
        self.collectionService = service
        fetchNft()
        fetchAuthorProfile()
    }

    func calculateCollectionViewHeight() -> CGFloat {
        let numberOfCells = catalogCollection.nfts.count
        let height = 192
        let spacing = 9
        var result: Int = 0
        if numberOfCells % 3 == 0 {
            result = ((numberOfCells / 3)) * height + ((numberOfCells / 3) * spacing)
        } else {
            result = (numberOfCells / 3 + 1) * height + ((numberOfCells / 3) * spacing)
        }
        return CGFloat(result)
    }

    private func fetchNft() {
        catalogCollection.nfts.forEach { id in
            collectionService.loadNftForCollection(id: String(id)) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                    if nfts.count == catalogCollection.nfts.count {
                        nftsLoadingIsCompleted = true
                    }
                case .failure(let error):
                    networkError = error
                }
            }
        }
    }

    private func fetchAuthorProfile() {
        collectionService.fetchAuthorProfile(id: catalogCollection.authorID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let author):
                self.author = author
            case .failure(let error):
                networkError = error
            }
        }
    }
}
