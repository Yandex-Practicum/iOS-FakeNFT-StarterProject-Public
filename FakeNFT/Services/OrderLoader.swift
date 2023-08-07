//
//  OrderLoader.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 02/08/2023.
//

import Foundation

//protocol OrderLoading {
//    func load(completion: @escaping (Result<[NFTModel], Error>) -> Void)
//    func update(with nftIds: [String], completion: @escaping (Result<[String], Error>) -> Void)
//}
//
//struct OrderLoader: OrderLoading {
//
//    // MARK: - Properties
//    
//    private let networkClient: NetworkClient
//
//    // MARK: - Lifecycle
//    
//    init(networkClient: NetworkClient = DefaultNetworkClient()) {
//        self.networkClient = networkClient
//    }
//
//    // MARK: - Public
//    
//    func load(completion: @escaping (Result<[NFTModel], Error>) -> Void) {
//        let getOrderRequest = GetOrderRequest()
//
//        networkClient.send(request: getOrderRequest, type: OrderModel.self) { result in
//            switch result {
//            case .success(let order):
//                var nftDict = [String: NFTModel]()
//                var requestsFinished = 0  {
//                    didSet {
//                        guard requestsFinished == order.nfts.count else { return }
//                        if nfts.count != order.nfts.count {
//                            completion(.failure(Errors.loadNFTError))
//                        } else {
//                            completion(.success(nfts))
//                        }
//                    }
//                }
//                order.nfts.forEach { nftId in
//                    loadNFT(by: nftId) { result in
//                        switch result {
//                        case .success(let nft):
//                            nftDict[nft.id] = nft
//                        case .failure(let error):
//                            print(error.localizedDescription)
//                        }
//                        requestsFinished += 1
//                    }
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func update(with nftIds: [String], completion: @escaping (Result<[String], Error>) -> Void) {
//        let putOrderRequest = PutOrderRequest(nftIds: nftIds)
//        networkClient.send(request: putOrderRequest, type: OrderModel.self) { result in
//            switch result {
//            case .success(let order):
//                completion(.success(order.nfts))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//
//    // MARK: - Private
//    
//    private func loadNFT(by id: String, completion: @escaping (Result<NFTModel, Error>) -> Void) {
//        let getNFTByIdRequest = GetNFTByIdRequest(id: id)
//        networkClient.send(request: getNFTByIdRequest, type: NFTModel.self) { result in
//            switch result {
//            case .success(let nft):
//                completion(.success(nft))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
//
//// MARK: - Nested types
//private extension OrderLoader {
//    enum Errors: Error {
//        case loadNFTError
//    }
//}
