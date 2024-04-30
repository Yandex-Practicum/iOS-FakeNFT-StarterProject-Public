import Foundation

typealias NftNetworkCompletion = (Result<NftModel, Error>) -> Void

protocol NftNetworkService {
    func loadNft(by id: String, completion: @escaping NftNetworkCompletion)
}

final class NftNetworkServiceImpl: NftNetworkService {

    private let networkClient: NetworkClient
    private let storage: NftNetworkStorage

    init(networkClient: NetworkClient, storage: NftNetworkStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    func loadNft(by id: String, completion: @escaping NftNetworkCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }
        
        let request = NftNetworkRequest(id: id)
        DispatchQueue.global(qos: .userInitiated).sync {
            networkClient.send(request: request, type: NftModel.self, completionQueue: .global(qos: .userInteractive)) { [weak storage] result in
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
}
