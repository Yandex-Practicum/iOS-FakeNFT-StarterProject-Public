import UIKit

enum Сonstants {
    static let ordersAPI: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/orders/1"
    static let nftAPI: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/nft/"
    static let defaultURL: URL = URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/")!
}

final class CartLoadModel {
    
    let networkClient: NetworkClient
    private (set) var nfts: [NFTServerModel] = []
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchNft(completion: @escaping (Result<[NFTServerModel], Error>) -> Void) {
        loadCart { result in
            switch result {
            case .success(let orderServer):
                orderServer.nfts.forEach { nftId in
                    self.loadNFT(id: nftId) { result in
                        switch result {
                        case .success(let nft):
                            self.nfts.append(nft)
                            print("IM HERE")
                            if self.nfts.count == orderServer.nfts.count {
                                completion(.success(self.nfts))
                                print(self.nfts)
                            }
                        case .failure(let error):
                            print(error)
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    private func loadCart(completion: @escaping (Result<OrderModel, Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint:URL(string: Сonstants.ordersAPI) , dto: nil, httpMethod: .get )
        networkClient.send(request: request, type: OrderModel.self, onResponse: completion)
    }
    
    private func loadNFT(id: String, completion: @escaping (Result<NFTServerModel, Error>) -> Void) {
        let request = DefaultNetworkRequest( endpoint: URL(string: Сonstants.nftAPI + "\(id)"), dto: nil, httpMethod: .get)
        networkClient.send(request: request, type: NFTServerModel.self, onResponse: completion)
    }
}

