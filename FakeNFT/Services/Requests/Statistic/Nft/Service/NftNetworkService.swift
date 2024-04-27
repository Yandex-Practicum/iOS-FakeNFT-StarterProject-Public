import Foundation

typealias NftNetworkCompletion = (Result<NftModel, Error>) -> Void

protocol NftNetworkService {
    func loadNft(by id: String, completion: @escaping NftNetworkCompletion)
}

final class NftNetworkServiceImpl: NftNetworkService {

    private let networkClient: NetworkClient
    private let storage: NftNetworkStorage

    init(networkClient: NetworkClient, storage: NftNetworkStorage) {
        print("SERVICE START")
        self.networkClient = networkClient
        self.storage = storage
    }
    
    func loadNft(by id: String, completion: @escaping NftNetworkCompletion) {
        if let nft = storage.getNft(with: id) {
            print("ZASHLO V GET")
            completion(.success(nft))
            return
        }
        
        print("NE ZASHLO V GET")
        let request = NftNetworkRequest(id: id)
        DispatchQueue.global(qos: .userInitiated).sync {
            networkClient.send(request: request, type: NftModel.self, completionQueue: .global(qos: .userInteractive)) { [weak storage] result in
                switch result {
                case .success(let nft):
                    print("1")
                    storage?.saveNft(nft)
                    completion(.success(nft))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
