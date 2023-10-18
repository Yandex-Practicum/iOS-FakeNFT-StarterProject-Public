import Foundation

final class DataProvider: DataProviderProtocol {
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
