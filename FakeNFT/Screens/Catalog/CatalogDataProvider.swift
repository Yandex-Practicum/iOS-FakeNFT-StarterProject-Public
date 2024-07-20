//
//  CatalogDataProvider.swift
//  FakeNFT
//
//  Created by Денис Николаев on 16.07.2024.
//

import Foundation
import ProgressHUD

// MARK: - Protocol

struct NFTTableViewRequest: NetworkRequest {
    var token: String?
    
    var endpoint: URL?
    
    init() {
        guard let endpoint = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/collections") else { return }
        self.endpoint = endpoint
        self.token = "edfc7835-684c-4eaf-a7b3-26ecea542ca3"
    }
}

protocol CatalogDataProviderProtocol: AnyObject {
    func fetchNFTCollection(completion: @escaping ([NFTCollection]) -> Void)
    func sortNFTCollections(by: NFTCollectionsSort)
    func getCollectionNFT() -> [NFTCollection]
}

// MARK: - Final Class

final class CatalogDataProvider: CatalogDataProviderProtocol {
    private var collectionNFT: [NFTCollection] = []
  
    let networkClient: DefaultNetworkClient
    
    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
    
    func getCollectionNFT() -> [NFTCollection] {
        return collectionNFT
    }
    
    func fetchNFTCollection(completion: @escaping ([NFTCollection]) -> Void) {
        ProgressHUD.show()
        networkClient.send(request: NFTTableViewRequest(), type: [NFTCollection].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nft):
                self.collectionNFT = nft
                completion(nft)
            case .failure(_):
                break
            }
            ProgressHUD.dismiss()
        }
    }
    
    func sortNFTCollections(by: NFTCollectionsSort) {
        switch by {
        case .name:
            collectionNFT.sort { $0.name < $1.name }
        case .nftCount:
            collectionNFT.sort { $0.nfts.count > $1.nfts.count }
        }
    }
}
