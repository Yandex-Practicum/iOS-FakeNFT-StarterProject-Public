import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    private let networkClient: NetworkClient
    private let profileId: String

    init(networkClient: NetworkClient, profileId: String) {
        self.networkClient = networkClient
        self.profileId = profileId
    }

    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = ProfileRequest(profileId: self.profileId)

        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let profile):
                    let normalizedProfile = self.normalizedProfile(profile)
                    completion(.success(normalizedProfile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func normalizedProfile(_ profile: Profile) -> Profile {
        let updatedAvatar = profile.avatar.replacingOccurrences(
            of: "https://cloudflare-ipfs.com/ipfs/",
            with: "https://ipfs.io/ipfs/"
        )
        
        let updatedNfts = profile.nfts.isEmpty ? [] : profile.nfts
        
        return Profile(
            id: profile.id,
            name: profile.name,
            avatar: updatedAvatar,
            description: profile.description,
            website: profile.website,
            nfts: updatedNfts,
            likes: profile.likes
        )
    }
}
