import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadNft(completion: @escaping ProfileCompletion)
    func updateLikes(profile: Profile, completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadNft(completion: @escaping ProfileCompletion) {

        let request = ProfileRequest(httpMethod: .get)
        networkClient
            .send(
                request: request,
                type: Profile.self
            ) { result in
                switch result {
                case .success(let profile):
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func updateLikes(profile: Profile, completion: @escaping ProfileCompletion) {
        
        let request = ProfilePutRequest(profile: profile)
        networkClient
            .send(
                request: request,
                type: Profile.self
            ) { result in
                switch result {
                case .success(let profile):
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
