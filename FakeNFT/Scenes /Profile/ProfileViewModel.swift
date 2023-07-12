import UIKit

final class ProfileViewModel {
    
    // MARK: - Properties
    var onChange: (() -> Void)?
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
    
    private(set) var nfts: [String]? {
        didSet {
            onChange?()
        }
    }
    
    private(set) var likes: [String]? {
        didSet {
            onChange?()
        }
    }
    
    private(set) var id: String?
    private(set) var error: Error?
    
    // MARK: - Lifecycle
    init(networkClient: NetworkClient?){
        if let networkClient = networkClient { self.networkClient = networkClient }
    }
    
    // MARK: - Methods
    func getProfileData() {
        UIBlockingProgressHUD.show()
        
        networkClient.send(request: GetProfileRequest(), type: ProfileNetworkModel.self) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.avatarURL = URL(string: profile.avatar)
                    self?.name = profile.name
                    self?.description = profile.description
                    self?.website = profile.website
                    self?.nfts = profile.nfts
                    self?.likes = profile.likes
                    self?.id = profile.id
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    self?.error = error
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
            likes: likes
        )
            
        networkClient.send(request: request, type: ProfileNetworkModel.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.avatarURL = URL(string: profile.avatar)
                    self?.name = profile.name
                    self?.description = profile.description
                    self?.website = profile.website
                    self?.nfts = profile.nfts
                    self?.likes = profile.likes
                    self?.id = profile.id
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    self?.error = error
                    self?.onError?()
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
}
