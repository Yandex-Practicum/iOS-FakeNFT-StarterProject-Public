import Foundation

final class ProfileDataProvider: ProfileDataProviderProtocol {
    let networkClient = DefaultNetworkClient()
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        let url = createURLWithPathAndQueryItems(path: Resources.Network.MockAPI.Paths.profile, queryItems: nil)
        let request = NetworkRequestModel(endpoint: url, httpMethod: .get)
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func changeProfile(profile: Profile, completion: @escaping (Result<Profile, Error>) -> Void) {
        let url = createURLWithPathAndQueryItems(path: Resources.Network.MockAPI.Paths.profile, queryItems: nil)
        let request = NetworkRequestModel(endpoint: url, httpMethod: .put, dto: profile)
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUsersNFT(userId: String?, nftsId: [String]?, completion: @escaping (Result<NFTCards, Error>) -> Void) {
        
        let queryItems = [URLQueryItem(name: "filter", value: userId)]
        let url = createURLWithPathAndQueryItems(path: Resources.Network.MockAPI.Paths.nftCard, queryItems: queryItems)
        
        let request = NetworkRequestModel(endpoint: url, httpMethod: .get)
        networkClient.send(request: request, type: NFTCards.self) { result in
            switch result {
            case .success(let result):
                var result = result
                if let userId {
                    result = result.filter { userId.contains($0.author) }
                }
                if let nftsId {
                    result = result.filter { nftsId.contains($0.id)}
                }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        
        let url = createURLWithPathAndQueryItems(path: Resources.Network.MockAPI.Paths.users, queryItems: nil)
        
        let request = NetworkRequestModel(endpoint: url,
                                          httpMethod: .get,
                                          dto: nil)
        networkClient.send(request: request, type: UsersResponse.self) { result in
            switch result {
            case .success(let usersResponse):
                let users = usersResponse.map { $0.convert() }
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    private func createURLWithPathAndQueryItems(path: String, queryItems: [URLQueryItem]?) -> URL? {
        
        let baseUrlString = Resources.Network.MockAPI.defaultStringURL
        
        guard var components = URLComponents(string: baseUrlString) else {
            return nil
        }
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}
