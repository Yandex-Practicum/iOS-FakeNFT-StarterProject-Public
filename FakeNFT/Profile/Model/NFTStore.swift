//
//  NFTStore.swift
//  FakeNFT
//

import Foundation

final class NFTStore {

    var networkClient: NetworkClient?
    weak var delegate: NFTStoreDelegate?

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - NFTStoreProtocol

extension NFTStore: NFTStoreProtocol {

    func get(_ nfts: [Int]) {
        nfts.forEach { nft in
            let nftPathComponentString = String(format: Constants.nftPathComponentString, nft)
            let nftRequest = NFTRequest(endpoint: URL(string: Constants.endpointURLString + nftPathComponentString))
            networkClient?.send(request: nftRequest, type: NFTModel.self) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let nftModel):
                        self?.delegate?.didReceive(nftModel)
                    case .failure(let error):
                        print("Error \(error): unable to get NFT with ID = \(nft), will try again")
                        self?.get([nft])
                    }
                }
            }
        }
    }

    func getСollections() {
        let сollectionsRequest = NFTRequest(endpoint: URL(string: Constants.endpointURLString + Constants.collectionsPathComponentString))
        networkClient?.send(request: сollectionsRequest, type: [CollectionModel].self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let collections):
                    self?.delegate?.didReceive(collections)
                case .failure(let error):
                    print("Error \(error): unable to get collections, will try again")
                    self?.getСollections()
                }
            }
        }
    }

    func getNames(for authorIDs: [AuthorViewModel]) {
        authorIDs.forEach { author in
            let userPathComponentString = String(format: Constants.userPathComponentString, author.id)
            let userRequest = NFTRequest(endpoint: URL(string: Constants.endpointURLString + userPathComponentString))
            networkClient?.send(request: userRequest, type: AuthorModel.self) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let userModel):
                        self?.delegate?.didReceive(userModel)
                    case .failure(let error):
                        print("Error \(error): unable to get user with ID = \(author.id), will try again")
                        self?.getNames(for: [author])
                    }
                }
            }
        }
    }
}
