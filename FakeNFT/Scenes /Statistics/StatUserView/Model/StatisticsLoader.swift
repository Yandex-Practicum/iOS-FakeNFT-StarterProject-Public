import Foundation

class StatisticsLoader {
    let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadUsers(completion: @escaping (Result<[ServerUserModel], Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint: Endpoint.getUsers(), dto: nil, httpMethod: .get)
        networkClient.send(request: request, type: [ServerUserModel].self, onResponse: completion)
    }
}
