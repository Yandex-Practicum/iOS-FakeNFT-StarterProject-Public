//
//  CollectionDataProvider.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation

// MARK: - Protocol

protocol  CollectionDataProviderProtocol: AnyObject {
    func fetchCollectionDataById(id: String, completion: @escaping (NFTCollection) -> Void)
    func getCollectionData() throws -> NFTCollection
    func loadNFTsBy(id: String, completion: @escaping (Result<Nft, Error>) -> Void)
    func updateUserProfile(with profile: ProfileModel, completion: @escaping (Result<ProfileModel, Error>) -> Void)
    func updateUserOrder(with order: OrderModel, completion: @escaping (Result<OrderModel, Error>) -> Void)
    func getUserProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void)
    func getUserOrder(completion: @escaping (Result<OrderModel, Error>) -> Void)
}

// MARK: - final class

final class CollectionDataProvider: CollectionDataProviderProtocol {

    enum CollectionDataError: Error {
        case dataNotFound
        case invalidData
    }

    private var collectionData: NFTCollection?
    private let networkClient: DefaultNetworkClient
    private var profile: ProfileModel?

    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }

    func getCollectionData() throws -> NFTCollection {
        return try self.collectionData ?? { throw CollectionDataError.dataNotFound }()
    }

    func fetchCollectionDataById(id: String, completion: @escaping (NFTCollection) -> Void) {
        networkClient.send(request: CollectionDataRequest(id: id), type: NFTCollection.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.collectionData = data
                completion(data)
            case .failure:
                break
            }
        }
    }

    func loadNFTsBy(id: String, completion: @escaping (Result<Nft, Error>) -> Void) {
        networkClient.send(request: NFTRequest(id: id), type: Nft.self) { result in
            completion(result)
        }
    }

    func updateUserProfile(with profile: ProfileModel, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        let updateRequest = ProfileUpdateRequest(profileModel: profile)
        networkClient.send(request: updateRequest, type: ProfileModel.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateUserOrder(with order: OrderModel, completion: @escaping (Result<OrderModel, Error>) -> Void) {
        let updateRequest = OrderUpdateRequest(order: order)
        networkClient.send(request: updateRequest, type: OrderModel.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getUserProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        networkClient.send(request: ProfileGetRequest(), type: ProfileModel.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getUserOrder(completion: @escaping (Result<OrderModel, Error>) -> Void) {
        networkClient.send(request: OrderGetRequest(), type: OrderModel.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
