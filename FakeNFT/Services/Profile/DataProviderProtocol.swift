import Foundation

protocol DataProviderProtocol {
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void)
    func changeProfile(profile: Profile, completion: @escaping (Result<Profile, Error>) -> Void)
}
