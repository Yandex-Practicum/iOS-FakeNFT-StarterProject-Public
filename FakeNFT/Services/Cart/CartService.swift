//
//  CartService.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 11.12.2023.
//

import Foundation

typealias CartCompletion = (Result<CartModel, Error>) -> Void
typealias NftsCompletion = (Result<[Nft], Error>) -> Void

protocol CartService {
    func downloadServiceNFTs(with id: String, completion: @escaping NftsCompletion)
    func removingFromCart(id: String, nftsID: [String], completion: @escaping CartCompletion)
}

final class CartServiceImpl: CartService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func downloadServiceNFTs(with id: String, completion: @escaping NftsCompletion) {
        downloadCart(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cartModel):
                if cartModel.nfts.isEmpty {
                    completion(.success([]))
                    return
                }
                let group = DispatchGroup()
                var nfts: [Nft] = []
                for nftId in cartModel.nfts {
                    group.enter()
                    self.downloadNft(id: nftId) { result in
                        defer { group.leave() }
                        switch result {
                        case .success(let nft):
                            nfts.append(nft)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
                group.notify(queue: .main) {
                    completion(.success(nfts))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func removingFromCart(id: String, nftsID: [String], completion: @escaping CartCompletion) {
        let request = CartRequestPut(id: id, nfts: nftsID)
        networkClient.send(request: request, type: CartModel.self, onResponse: completion)
    }

    private func downloadCart(id: String, completion: @escaping CartCompletion) {
        let request = CartRequest(id: id)
        networkClient.send(request: request, type: CartModel.self, onResponse: completion)
    }

    private func downloadNft(id: String, completion: @escaping NftCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self, onResponse: completion)
    }
}
