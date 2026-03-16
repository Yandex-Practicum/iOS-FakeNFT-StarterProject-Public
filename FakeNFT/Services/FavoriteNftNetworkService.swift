import Foundation

final class FavoriteNftNetworkService: FavoriteNftService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getFavorites(completion: @escaping (Result<[String], Error>) -> Void) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self, onResponse: { result in
            switch result {
            case .success(let profile):
                completion(.success(profile.likes))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func toggleFavorite(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        getFavorites { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(var currentLikes):
                if let index = currentLikes.firstIndex(of: id) {
                    currentLikes.remove(at: index)
                } else {
                    currentLikes.append(id)
                }
                let updateRequest = UpdateProfileLikesRequest(likes: currentLikes)
                self.networkClient.send(request: updateRequest, type: Profile.self, onResponse: { response in
                    switch response {
                    case .success(let profile):
                        completion(.success(profile.likes))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

