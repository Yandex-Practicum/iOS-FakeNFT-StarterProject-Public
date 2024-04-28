//
//  CartControllerStub.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

final class CartServiceStub: CartServiceProtocol {
    
    weak var delegate: CartServiceDelegate?
    
    private(set) var cartItems = [NFT]()
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchData(with id: String,
                   completion: @escaping (Result<[NFT], Error>) -> Void) {
        let request = CartItemsRequest(id: "1")
        networkManager.send(
            request: request,
            type: OrderResponse.self,
            id: request.requestId) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let items):
                    var nfts: [NFT] = []
                    
                    guard !items.nfts.isEmpty else {
                        return completion(.success(nfts))
                    }
                    
                    items.nfts.forEach{
                        self.fetchNFTItem(id: $0){ result in
                            switch result{
                            case .success(let nft):
                                nfts.append(nft)
                                if nfts.count == items.nfts.count {
                                    self.cartItems = nfts
                                    completion(.success(nfts))
                                }
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func addToCart(_ nft: NFT, completion: (() -> Void)?) {
        cartItems.append(nft)
        completion?()
    }
    
    func removeFromCart(with id: String,
                        completion: @escaping (Result<OrderResponse, Error>) -> Void) {
        guard let index = cartItems.firstIndex(where: { $0.id == id }) else { return }
        let nftsString = self.cartItems.map{ $0.id }
        
        let request = CartPutRequest(id: id, nfts: nftsString)
        
        networkManager.send(request: request,
                            type: OrderResponse.self,
                            id: request.requestId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.cartItems.remove(at: index)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func removeAll(completion: (() -> Void)?) {
        cartItems.removeAll()
        delegate?.cartCountDidChanged(cartItems.count)
        completion?()
    }
}

// MARK: Private Methods
private extension CartServiceStub {
    
    func fetchNFTItem(id: String, completion: @escaping NftCompletion) {
        let request = NFTRequest(id: id)
        networkManager.send(request: request,
                            type: NFT.self,
                            id: request.id,
                            completion: completion)
    }
}
