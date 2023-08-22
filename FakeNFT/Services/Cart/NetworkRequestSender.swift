import Foundation

protocol NetworkRequestSenderProtocol {
    func send<RequestType: Decodable>(
        request: NetworkRequest,
        task: NetworkTask?,
        type: RequestType.Type,
        completion: @escaping ResultHandler<RequestType>
    ) -> DefaultNetworkTask?
}

final class NetworkRequestSender: NetworkRequestSenderProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func send<RequestType: Decodable>(
        request: NetworkRequest,
        task: NetworkTask?,
        type: RequestType.Type,
        completion: @escaping ResultHandler<RequestType>
    ) -> DefaultNetworkTask? {
        let newTask = self.networkClient.send(request: request, type: RequestType.self) { result in
            task?.cancel()
            completion(result)
        }

        return newTask as? DefaultNetworkTask
    }
}
