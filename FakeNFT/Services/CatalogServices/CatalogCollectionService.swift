//
//  CatalogCollectionService.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 13.11.2023.
//

import Foundation

protocol CatalogCollectionServiceProtocol {
    func loadNftForCollection(id: String, completion: @escaping (Result<Nft, Error>) -> Void)
    func fetchAuthorProfile(id: String, completion: @escaping (Result<Author, Error>) -> Void)
//    func fetchProfileLikes(completion: @escaping (Result<ProfileLike, Error>) -> Void)
    func putProfileLikes(profile: ProfileLike, completion: @escaping (Result<ProfileLike, Error>) -> Void)
    func putNftsToCart(cart: PurchaseCart, completion: @escaping (Result<PurchaseCart, Error>) -> Void)
}

final class CatalogCollectionService: CatalogCollectionServiceProtocol {

    // MARK: - Public properties
    private var catalog: [Catalog] = []

    // MARK: - Private properties
    private let networkClient: NetworkClient
    private let storage: NftStorage = NftStorageImpl.shared
    private lazy var queue = DispatchQueue.global(qos: .userInitiated)

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Public methods
    func loadNftForCollection(id: String, completion: @escaping (Result<Nft, Error>) -> Void) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)

        queue.async { [weak self] in
            guard let self = self else { return }
            networkClient.send(
                request: request,
                type: Nft.self,
                onResponse: { (result: Result<Nft, Error>) in
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        switch result {
                        case .success(let nft):
                            storage.saveNft(nft)
                            completion(.success(nft))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            )
        }
    }

    func fetchAuthorProfile(id: String, completion: @escaping (Result<Author, Error>) -> Void) {
        let request = AuthorRequest(id: id)

        queue.async { [weak self] in
            guard let self = self else { return }
            networkClient.send(
                request: request,
                type: Author.self,
                onResponse: { (result: Result<Author, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let author):
                            completion(.success(author))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            )
        }
    }

    func putProfileLikes(profile: ProfileLike, completion: @escaping (Result<ProfileLike, Error>) -> Void) {
        let request = ProfileRequest(httpMethod: .put, dto: profile)

        queue.async { [weak self] in
            guard let self = self else { return }
            networkClient.send(
                request: request,
                type: ProfileLike.self) { (result: Result<ProfileLike, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let profile):
                            completion(.success(profile))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
        }
    }

    func putNftsToCart(cart: PurchaseCart, completion: @escaping (Result<PurchaseCart, Error>) -> Void) {
        let request = OrdersRequest(httpMethod: .put, dto: cart)

        queue.async { [weak self] in
            guard let self = self else { return }
            networkClient.send(
                request: request,
                type: PurchaseCart.self) { (result: Result<PurchaseCart, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let cart):
                            completion(.success(cart))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
        }
    }
}
