//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 03.07.2023.
//

import Foundation
import Combine

final class CatalogCollectionViewModel {
    @Published private (set) var nftCollection: NftCollection
    @Published private (set) var visibleNfts: [SingleNft] = []
    
    private let networkClient: NetworkClient
        
    init(nftCollection: NftCollection, networkClient: NetworkClient) {
        self.nftCollection = nftCollection
        self.networkClient = networkClient
    }
    
    func updateNfts(from collection: NftCollection) {
        collection.nfts.forEach { [weak self] id in
            let request = RequestConstructor.constructNftCollectionRequest(method: .get, collectionId: id)
            self?.networkClient.send(request: request, type: SingleNft.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    self.visibleNfts.append(nft)
                case .failure(_):
                    print("Failure")
                }
            }
        }
    }
}
