import Foundation

final class ProfileService {
    static let shared = ProfileService(networkHelper: NetworkServiceHelper(networkClient: DefaultNetworkClient()))
    
    private let networkHelper: NetworkServiceHelper
    
    init(networkHelper: NetworkServiceHelper) {
        self.networkHelper = networkHelper
    }
    
    func fetchProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let request = FetchProfileNetworkRequest()
        networkHelper.fetchData(request: request, type: UserProfile.self) { result in
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
        networkHelper.fetchData(request: request, type: UserProfile.self) { result in
            switch result {
            case .success(let updatedProfile):
                completion(.success(updatedProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func stopAllTasks() {
        networkHelper.stopAllTasks()
    }
}
