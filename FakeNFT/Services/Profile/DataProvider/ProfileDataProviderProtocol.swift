import Foundation

protocol ProfileDataProviderProtocol {
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void)
    func changeProfile(profile: Profile, completion: @escaping (Result<Profile, Error>) -> Void)
    func fetchUsersNFT(userId: String?, nftsId: [String]?, completion: @escaping (Result<NFTCards, Error>) -> Void)
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void)
}
