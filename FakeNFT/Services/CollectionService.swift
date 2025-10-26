import Foundation

typealias CollectionsCompletion = (Result<[NFTCollection], Error>) -> Void

protocol CollectionService {
    func loadCollections(completion: @escaping CollectionsCompletion)
}

final class CollectionServiceImpl: CollectionService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCollections(completion: @escaping CollectionsCompletion) {
        let request = CollectionsRequest()
        networkClient.send(request: request, type: [NFTCollection].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let collections):
                    completion(.success(collections))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
