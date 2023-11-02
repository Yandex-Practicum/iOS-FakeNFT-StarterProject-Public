import Foundation

struct StatisticsUserNFTCollectionModel {
    private enum NetworkError: Error {
        case someError
    }

    let networkClient: NetworkClient

    func loadNFT(id: String, completion: @escaping (Result<StatisticsNFTModel, Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint: Endpoint.getNFT(id: id), dto: nil, httpMethod: .get)
        networkClient.send(request: request, type: StatisticsNFTModel.self, onResponse: completion)
    }
}
