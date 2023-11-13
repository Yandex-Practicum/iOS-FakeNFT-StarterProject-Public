import Foundation

struct UserProfileModel: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

final class ProfileModel {
    private let networkClient: NetworkClient

    init() {
        self.networkClient = DefaultNetworkClient()
    }

    func fetchProfile(request: NetworkRequest = FetchProfileNetworkRequest(),
                      completion: @escaping (Result<UserProfileModel, Error>) -> Void) {
        networkClient.send(request: request, type: UserProfileModel.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateProfile(with userProfileModel: UserProfileModel,
                       completion: @escaping (Result<UserProfileModel, Error>) -> Void) {
        let request = UpdateProfileNetworkRequest(userProfile: userProfileModel)
        networkClient.send(request: request, type: UserProfileModel.self) { result in
            switch result {
            case .success(let updatedProfile):
                completion(.success(updatedProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
