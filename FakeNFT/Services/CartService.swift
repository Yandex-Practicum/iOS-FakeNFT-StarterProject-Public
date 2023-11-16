import Foundation

typealias CartCompletion = (Result<CartModel, Error>) -> Void
typealias NftsCompletion = (Result<[Nft], Error>) -> Void

protocol CartService {
    func loadNFTs(completion: @escaping NftsCompletion)
    func deleteNftFromCart(cartId: String, nfts: [String], completion: @escaping CartCompletion)
}

final class CartServiceImpl: CartService {
    private let networkClient: NetworkClient
    private let storage: CartStorage

    init(networkClient: NetworkClient, storage: CartStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadCart(completion: @escaping CartCompletion) {
        let request = CartRequest()
        networkClient.send(request: request, type: CartModel.self, onResponse: completion)
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self, onResponse: completion)
    }

    func loadNFTs(completion: @escaping NftsCompletion) {
        let group = DispatchGroup()
        var nfts: [Nft] = []
        loadCart { result in
            switch result {
            case .success(let cart):
                for nftId in cart.nfts {
                    group.enter()
                    self.loadNft(id: nftId) { result in
                        defer { group.leave() }
                        switch result {
                        case .success(let nft):
                            nfts.append(nft)
                        case .failure(let error):
                            completion(.failure(error))
                            return
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
            group.notify(queue: .main) {
                completion(.success(nfts))
            }
        }
    }

    func deleteNftFromCart(cartId: String = "1", nfts: [String], completion: @escaping CartCompletion) {
        let request =  NFTNetworkRequest(endpoint: CartRequest().endpoint,
                                         httpMethod: .put,
                                         dto: CartModel(id: cartId, nfts: nfts))
        networkClient.send(request: request, type: CartModel.self, onResponse: completion)
    }
}
