//
//  CatalogDataProvider.swift
//  FakeNFT
//
//  Created by Денис Николаев on 16.07.2024.
//

import Foundation

// MARK: - Protocol

protocol CatalogDataProviderProtocol: AnyObject {
    func fetchNFTCollection(
        completion: @escaping (
            [NFTCollection]
        ) -> Void
    )
    func sortNFTCollections(
        by: NFTCollectionsSort
    )
    func getCollectionNFT() -> [NFTCollection]
}

// MARK: - Final Class

final class CatalogDataProvider: CatalogDataProviderProtocol {
    private var collectionNFT: [NFTCollection] = []

    let networkClient: DefaultNetworkClient

    init(
        networkClient: DefaultNetworkClient
    ) {
        self.networkClient = networkClient
    }

    func getCollectionNFT() -> [NFTCollection] {
        return collectionNFT
    }

    func fetchNFTCollection(
        completion: @escaping (
            [NFTCollection]
        ) -> Void
    ) {
        networkClient.send(
            request: NFTTableViewRequest(),
            type: [NFTCollection].self
        ) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(
                let nft
            ):
                self.collectionNFT = nft
                completion(
                    nft
                )
            case .failure:
                break
            }
        }
    }

    func sortNFTCollections(
        by: NFTCollectionsSort
    ) {
        switch by {
        case .name:
            collectionNFT.sort {
                $0.name < $1.name
            }
        case .nftCount:
            collectionNFT.sort {
                $0.nfts.count > $1.nfts.count
            }
        }
    }
}
