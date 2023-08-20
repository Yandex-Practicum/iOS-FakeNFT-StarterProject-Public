import Foundation

protocol EditProfileViewModelProtocol: AnyObject {
    var profile: ProfileModel? { get set }
    var error: Error? { get }
    
    func updateProfile()
}

final class EditProfileViewModel: EditProfileViewModelProtocol {
    private var networkClient: NetworkClient = DefaultNetworkClient()

    var profile: ProfileModel?
    private(set) var error: Error?
    
//    var updateProfile: ((ProfileModel) -> Void)?
    
    init(networkClient: NetworkClient? = nil, profile: ProfileModel) {
        self.profile = profile
        if let networkClient = networkClient { self.networkClient = networkClient }
    }
    
    func updateProfile() {
        networkClient.send(request: ProfileRequest(httpMethod: .put, dto: profile), type: ProfileModel.self) { _ in
            return
        }
    }
    
    func updateAvatar(withLink newLink: String) {
        profile?.avatar = newLink
        updateProfile()
    }
}
