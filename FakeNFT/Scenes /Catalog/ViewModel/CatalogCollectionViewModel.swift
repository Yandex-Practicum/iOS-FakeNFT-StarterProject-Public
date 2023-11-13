//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import Foundation
import Combine

protocol CatalogCollectionViewModelProtocol: AnyObject {
    var nft: [Nft]? { get }
    var catalogCollection: Catalog { get }
    func calculateCollectionViewHeight() -> CGFloat
}

final class CatalogCollectionViewModel: CatalogCollectionViewModelProtocol {

    var nft: [Nft]?
    var catalogCollection: Catalog
    var networkError: Error?

    private let nftService: NftService

    init(catalogCollection: Catalog, service: NftService) {
        self.catalogCollection = catalogCollection
        self.nftService = service
    }

    func fetchNft() {
//        isLoadingData = true
        var nftId = 1
        catalogCollection.nfts.forEach { _ in
            nftService.loadNft(id: String(nftId)) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    self.nft?.append(nft)
    //                isLoadingData = false
    //                catalog = catalogRes
    //                sortCatalog()
                case .failure(let error):

    //                isLoadingData = false
                    networkError = error
                }
            }
            nftId += 1
        }

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
}
