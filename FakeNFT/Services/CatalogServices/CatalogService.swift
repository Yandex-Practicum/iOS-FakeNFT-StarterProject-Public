//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import Foundation

protocol CatalogServiceProtocol {
    func fetchCatalog(completion: @escaping (Result<[Catalog], Error>) -> Void)
    func fetchProfileLikes(completion: @escaping (Result<ProfileLike, Error>) -> Void)
    func fetchAddedToBasketNfts(completion: @escaping (Result<PurchaseCart, Error>) -> Void)
}

final class CatalogService: CatalogServiceProtocol {

    // MARK: - Public properties
    private var catalog: [Catalog] = []

    // MARK: - Private properties
    private let request = CatalogRequest()
    private let networkClient: NetworkClient
    private lazy var queue = DispatchQueue.global(qos: .userInitiated)

    init(networkClient: NetworkClient) {
        self.networkClient = DefaultNetworkClient()
    }

    // MARK: - Public methods
    func fetchCatalog(completion: @escaping (Result<[Catalog], Error>) -> Void) {

        queue.async { [weak self] in
            guard let self = self else { return }
            self.networkClient.send(
                request: self.request,
                type: [CatalogResult].self,
                onResponse: { [weak self] (result: Result<[CatalogResult], Error>)  in
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        switch result {
                        case .success(let catalogRes):
                            self.catalog += catalogRes.map {
                                return Catalog(
                                    name: $0.name,coverURL: URL(string: $0.cover.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""),
                                    nfts: $0.nfts,
                                    desription: $0.description,
                                    authorID: $0.author,
                                    id: $0.id)
                            }
                            completion(.success(self.catalog))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            )
        }
    }

    // methods implemented for temporary use in catalog epic to handle likes and addToBasket interaction
    // when the full project is merged - these two methods will be removed
    // both methods should be implemented in Profile epic
    func fetchProfileLikes(completion: @escaping (Result<ProfileLike, Error>) -> Void) {
        let request = ProfileRequest(httpMethod: .get)

        queue.async { [weak self] in
            guard let self = self else { return }
            self.networkClient.send(
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

    func fetchAddedToBasketNfts(completion: @escaping (Result<PurchaseCart, Error>) -> Void) {
        let request = OrdersRequest(httpMethod: .get)

        queue.async { [weak self] in
            guard let self = self else { return }
            self.networkClient.send(
                request: request,
                type: PurchaseCart.self) { (result: Result<PurchaseCart, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let order):
                            completion(.success(order))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
        }
    }
}
