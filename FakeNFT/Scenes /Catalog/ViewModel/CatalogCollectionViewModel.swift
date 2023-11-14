//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import Foundation
import Combine

protocol CatalogCollectionViewModelProtocol: AnyObject {
    var nfts: [NftModel] { get }
    var nftPublisher: Published<Array<NftModel>>.Publisher { get }
    var catalogCollection: Catalog { get }
    func calculateCollectionViewHeight() -> CGFloat
}

final class CatalogCollectionViewModel: CatalogCollectionViewModelProtocol {

    @Published var nfts: [NftModel] = []
    var nftPublisher: Published<Array<NftModel>>.Publisher { $nfts }
    var catalogCollection: Catalog
    var networkError: Error?

    private let nftService: NftService

    init(catalogCollection: Catalog, service: NftService) {
        self.catalogCollection = catalogCollection
        self.nftService = service
        fetchNft()
//        fetchNft1()
    }

    func fetchNft() {
//        isLoadingData = true

        catalogCollection.nfts.forEach { id in
            nftService.loadNftForCollection(id: String(id)) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    print("ok")
                    self.nfts.append(nft)
    //                isLoadingData = false
    //                catalog = catalogRes
    //                sortCatalog()
                case .failure(let error):

    //                isLoadingData = false
                    networkError = error
                }
            }
        }

    }

    func fetchNft1() {
//        isLoadingData = true

        catalogCollection.nfts.forEach { id in
            nftService.loadNft(id: String(id)) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    print("hello")
//                    self.nfts.append(nft)
    //                isLoadingData = false
    //                catalog = catalogRes
    //                sortCatalog()
                case .failure(let error):

    //                isLoadingData = false
                    networkError = error
                }
            }
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
