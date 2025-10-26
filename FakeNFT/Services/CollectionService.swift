import Foundation

typealias CollectionsCompletion = (Result<[NFTCollection], Error>) -> Void

protocol CollectionService {
    func loadCollections(completion: @escaping CollectionsCompletion)
}

final class CollectionServiceImpl: CollectionService {
    private let networkClient: NetworkClient
    private var cachedCollections: [NFTCollection]?
        private var isLoading = false
        private var completions: [CollectionsCompletion] = []
        
        init(networkClient: NetworkClient) {
            self.networkClient = networkClient
        }
        
        func loadCollections(completion: @escaping CollectionsCompletion) {
            if let cachedCollections = cachedCollections {
                completion(.success(cachedCollections))
                return
            }
            
            if isLoading {
                completions.append(completion)
                return
            }
            
            isLoading = true
            
            let request = CollectionsRequest()
            networkClient.send(request: request, type: [NFTCollection].self) { [weak self] result in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    switch result {
                    case .success(let collections):
                        self.cachedCollections = collections
                        completion(.success(collections))
                        
                        self.completions.forEach { $0(.success(collections)) }
                        self.completions.removeAll()
                        
                    case .failure(let error):
                        completion(.failure(error))
                        self.completions.forEach { $0(.failure(error)) }
                        self.completions.removeAll()
                    }
                }
            }
        }
    }
