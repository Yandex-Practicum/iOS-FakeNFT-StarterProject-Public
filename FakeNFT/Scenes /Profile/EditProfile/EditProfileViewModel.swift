import Foundation

protocol EditProfileViewModelProtocol: AnyObject {
    var profile: ProfileModel? { get }
    var error: Error? { get }
    
    func updateProfile(profile: ProfileModel)
}

final class EditProfileViewModel: EditProfileViewModelProtocol {
    private var networkClient: NetworkClient = DefaultNetworkClient()

    private(set) var profile: ProfileModel?
    private(set) var error: Error?
    
    var updateProfile: ((ProfileModel) -> Void)?
    
    init(networkClient: NetworkClient? = nil, profile: ProfileModel) {
        self.profile = profile
        if let networkClient = networkClient { self.networkClient = networkClient }
    }
    
    func updateProfile(profile: ProfileModel) {
        networkClient.send(request: ProfileRequest(httpMethod: .put, dto: profile), type: ProfileModel.self) { _ in
            return
        }
    }
}
