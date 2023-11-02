import Foundation

struct UserProfileModel: Decodable {
    let name: String
    let avatar: URL
    let description: String
    let website: URL
    let nfts: [String]
    let rating: String
    let id: String
}

struct StatisticsUserProfileModel {
    let networkClient: NetworkClient

    func loadUser(id: String, completion: @escaping (Result<UserProfileModel, Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint: Endpoint.getProfile(id: id), dto: nil, httpMethod: .get)
        networkClient.send(request: request, type: UserProfileModel.self, onResponse: completion)
    }
}
