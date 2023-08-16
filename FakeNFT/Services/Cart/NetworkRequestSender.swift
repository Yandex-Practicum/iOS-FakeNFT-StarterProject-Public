import Foundation

protocol NetworkWorkerProtocol {
    func send<RequestType: Decodable>(
        request: NetworkRequest,
        task: NetworkTask?,
        type: RequestType,
        completion: @escaping ResultHandler<RequestType>
    ) -> NetworkTask?
}

final class NetworkRequestSender: NetworkWorkerProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func send<RequestType: Decodable>(
        request: NetworkRequest,
        task: NetworkTask?,
        type: RequestType,
        completion: @escaping ResultHandler<RequestType>
    ) -> NetworkTask? {
        var activeTask = task

        let newTask = self.networkClient.send(request: request, type: RequestType.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                activeTask?.cancel()
                activeTask = nil
                completion(result)
            }
        }

        return newTask
    }
}
