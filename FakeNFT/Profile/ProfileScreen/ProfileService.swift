import Foundation

final class ProfileService {
    static let shared = ProfileService(networkClient: DefaultNetworkClient())
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProfile(request: NetworkRequest = FetchProfileNetworkRequest(),
                      completion: @escaping (Result<UserProfile, Error>) -> Void) {
        networkClient.send(request: request, type: UserProfile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(with userProfileModel: UserProfile,
                       completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let request = UpdateProfileNetworkRequest(userProfile: userProfileModel)
        networkClient.send(request: request, type: UserProfile.self) { result in
            switch result {
            case .success(let updatedProfile):
                completion(.success(updatedProfile))
                NotificationCenter.default.post(name: NSNotification.Name("profileUpdated"), object: nil)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
