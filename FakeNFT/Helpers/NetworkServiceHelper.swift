import Foundation

final class NetworkServiceHelper {
    private let networkClient: NetworkClient
    private var currentTasks: [NetworkTask] = []
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchData<T: Decodable>(request: NetworkRequest, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        fetchData(request: request, type: T.self, retryCount: 0, delayInterval: 3.0, completion: completion)
    }
    
    func stopAllTasks() {
        currentTasks.forEach { $0.cancel() }
        currentTasks.removeAll()
    }
    
    private func fetchData<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        retryCount: Int,
        delayInterval: Double,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let task = networkClient.send(request: request, type: T.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if retryCount < 3 {
                    if case NetworkClientError.httpStatusCode(429) = error {
                        let newRetryCount = retryCount + 1
                        let newDelayInterval = delayInterval * 2
                        DispatchQueue.global().asyncAfter(deadline: .now() + delayInterval) {
                            self.fetchData(request: request, type: T.self, retryCount: newRetryCount, delayInterval: newDelayInterval, completion: completion)
                        }
                    } else {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error))
                }
            }
        }
        
        guard let unwrappedTask = task else {
            completion(.failure(NetworkClientError.taskCreationFailed))
            return
        }
        
        self.currentTasks.append(unwrappedTask)
    }
}
