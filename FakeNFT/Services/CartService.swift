import Foundation

typealias NftsCompletion = (Result<[Nft], Error>) -> Void
typealias CartCompletion = (Result<CartModel, Error>) -> Void

protocol CartService {
    func loadNFTs(completion: @escaping NftsCompletion)
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
        loadCart { result in
            switch result {
            case .success(let cartModel):
                var nfts: [Nft] = []
                cartModel.nfts.forEach {
                    self.loadNft(id: $0) { result in
                        switch result {
                        case .success(let nft):
                            nfts.append(nft)
                            if nfts.count == cartModel.nfts.count {
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
}
