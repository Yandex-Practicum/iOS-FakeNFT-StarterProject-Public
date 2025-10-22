//
//  MyNFTService.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 30.03.2025.
//


import Foundation


typealias MyNftCompletion = (Result<MyNFT, Error>) -> Void

protocol MyNftService {
    func loadNft(id: String, completion: @escaping MyNftCompletion)
}

final class MyNftServiceImpl: MyNftService {

    private let networkClient: NetworkClient
    private let storage: MyNftStorage

    init(networkClient: NetworkClient, storage: MyNftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping MyNftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: MyNFT.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
