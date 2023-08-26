//
//  OrderService.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 15/08/2023.
//

import Foundation

protocol OrderServiceProtocol {
    func makePayment(currencyId: String, completion: @escaping (Result<PaymentModel, Error>) -> Void)
}

final class OrderService: OrderServiceProtocol {
    static let shared = OrderService()
    private let networkClient: NetworkClient
    private var currencyTask: NetworkTask?

    private init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    func getOrder(completion: @escaping (Result<[String], Error>) -> Void) {
        assert(Thread.isMainThread)

        if currencyTask != nil {
            return
        }
        
        let getOrderRequest = GetOrderRequest(httpMethod: .get)
        currencyTask = networkClient.send(request: getOrderRequest, type: OrderModel.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order.nfts))
            case .failure(let error):
                completion(.failure(error))
            }
            self.currencyTask = nil
        }
    }
    
    func loadNFT(by id: String, completion: @escaping (Result<NftModel, Error>) -> Void) {
        let getNFTByIdRequest = GetNFTByIdRequest(id: id, httpMethod: .get)
        networkClient.send(request: getNFTByIdRequest, type: NftModel.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNFTModels(completion: @escaping ([NftModel]?) -> Void) {
        getOrder { result in
            switch result {
            case .success(let orderIds):
                let group = DispatchGroup()
                var nfts: [NftModel] = []
                
                for nftId in orderIds {
                    group.enter()
                    self.loadNFT(by: nftId) { result in
                        switch result {
                        case .success(let nft):
                            nfts.append(nft)
                        case .failure(let error):
                            print("Error fetching NFT for ID \(nftId): \(error)")
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    print("All NFTs fetched. NFTs: \(nfts)")
                    completion(nfts)
                }
                
            case .failure(let error):
                print("Error with fetching NFTs: \(error)")
                completion(nil)
            }
        }
    }

    func updateOrder(with nftIds: [String], completion: @escaping (Result<[String], Error>) -> Void) {
        assert(Thread.isMainThread)

        if currencyTask != nil {
            return
        }
        
        let putOrderRequest = PutOrderRequest(nftIds: nftIds)
        currencyTask = networkClient.send(request: putOrderRequest, type: OrderModel.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order.nfts))
            case .failure(let error):
                completion(.failure(error))
            }
            self.currencyTask = nil
        }
    }
    
    func makePayment(currencyId: String, completion: @escaping (Result<PaymentModel, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if currencyTask != nil {
            return
        }
        
        let getPaymentRequest = GetPaymentRequest(httpMethod: .get, currencyId: currencyId)
        currencyTask = networkClient.send(request: getPaymentRequest, type: PaymentModel.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
            self.currencyTask = nil
        }
    }
}
