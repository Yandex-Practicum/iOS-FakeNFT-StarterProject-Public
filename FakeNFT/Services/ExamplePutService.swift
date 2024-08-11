import Foundation

typealias ExamplePutCompletion = (Result<ExamplePutResponse, Error>) -> Void

protocol ExamplePutService {
    func sendExamplePutRequest(
        param1: String,
        param2: String,
        completion: @escaping ExamplePutCompletion
    )
}

final class ExamplePutServiceImpl: ExamplePutService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func sendExamplePutRequest(
        param1: String,
        param2: String,
        completion: @escaping ExamplePutCompletion
    ) {
        let dto = ExampleDtoObject(param1: param1, param2: param2)
        let request = ExamplePutRequest(dto: dto)
        networkClient.send(request: request, type: ExamplePutResponse.self) { result in
            switch result {
            case .success(let putResponse):
                completion(.success(putResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
