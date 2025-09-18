import Foundation

final class CartService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCart(orderId: String, completion: @escaping (Result<[NFTModel], Error>) -> Void) {
        let request = CartRequest(orderId: orderId)
        
        networkClient.send(request: request, type: CartResponse.self) { [weak self] result in
            switch result {
            case .success(let cartResponse):
                self?.fetchNFTs(ids: cartResponse.nfts, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchNFTs(ids: [String], completion: @escaping (Result<[NFTModel], Error>) -> Void) {
        let group = DispatchGroup()
        var results: [NFTModel] = []
        var caughtError: Error?
        
        for id in ids {
            group.enter()
            let request = NFTRequest(id: id)
            networkClient.send(request: request, type: NFTModel.self) { result in
                switch result {
                case .success(let nft):
                    results.append(nft)
                case .failure(let error):
                    caughtError = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = caughtError {
                completion(.failure(error))
            } else {
                completion(.success(results))
            }
        }
    }
    func updateNfts(orderId: String,nfts:[String],  completion: @escaping ((Result<CartResponse, Error>) -> Void)){
        let dto = CartUpdateDto(nfts: nfts)
        let request = CartDeleteRequest(dto: dto, orderId: orderId)
        networkClient.send(request: request, type: CartResponse.self) { result in
            completion(result)
        }
    }
}
