import Foundation

protocol ProfileViewModelProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }
    var onLoaded: (() -> Void)? { get set }
    var onError: (() -> Void)? { get set }

    var avatarURL: URL? { get }
    var name: String? { get }
    var description: String? { get }
    var website: String? { get }
    var likes: [String]? { get }
    var nfts: [String]? { get }
    var id: String? { get }
    var error: Error? { get }

    func getProfileData()
    func putProfileData(name: String, avatar: String, description: String, website: String, likes: [String])
}

final class ProfileViewModel: ProfileViewModelProtocol {
    var onChange: (() -> Void)?
    var onLoaded: (() -> Void)?
    var onError: (() -> Void)?

    private var networkClient: NetworkClient = DefaultNetworkClient()

    private(set) var avatarURL: URL? {
        didSet {
            onChange?()
        }
    }

    private(set) var name: String? {
        didSet {
            onChange?()
        }
    }

    private(set) var description: String? {
        didSet {
            onChange?()
        }
    }

    private(set) var website: String? {
        didSet {
            onChange?()
        }
    }

    private(set) var likes: [String]? {
        didSet {
            onChange?()
            onLoaded?()
        }
    }
    
    private(set) var nfts: [String]? {
        didSet {
            onChange?()
            onLoaded?()
        }
    }

    private(set) var id: String?
    private(set) var error: Error?

    init(networkClient: NetworkClient? = nil) {
        if let networkClient = networkClient { self.networkClient = networkClient }
    }
    
    func getProfileData() {
        UIBlockingProgressHUD.show()
        
        networkClient.send(request: GetProfileRequest(), type: ProfileNetworkModel.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.fillFrom(response: profile)
                    self?.nfts = profile.nfts
                    self?.likes = profile.likes
                    UIBlockingProgressHUD.dismiss()
                case .failure(let failure):
                    self?.error = failure
                    self?.onError?()
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }

    func putProfileData(name: String, avatar: String, description: String, website: String, likes: [String]) {
        UIBlockingProgressHUD.show()

        let request = PutProfileRequest(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            likes: likes)

        networkClient.send(request: request, type: ProfileNetworkModel.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.fillFrom(response: profile)
                    UIBlockingProgressHUD.dismiss()
                case .failure(let failure):
                    self?.error = failure
                    self?.onError?()
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    private func fillFrom(response: ProfileNetworkModel){
        self.avatarURL = URL(string: response.avatar)
        self.name = response.name
        self.description = response.description
        self.website = response.website
        self.id = response.id
    }
}
