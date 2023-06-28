import UIKit

final class ProfileViewModel {
    
    // MARK: - Properties
    var onChange: (() -> Void)?
    
    private weak var viewController: UIViewController?
    
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
    
    // MARK: - Lifecycle
    init(viewController: UIViewController){
        self.viewController = viewController
        getProfileData()
    }
    
    // MARK: - Methods
    func getProfileData() {
        UIBlockingProgressHUD.show()
        let networkClient = DefaultNetworkClient()
        
        networkClient.send(request: GetProfileRequest(), type: ProfileNetworkModel.self) { [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.avatarURL = URL(string: profile.avatar)
                    self.name = profile.name
                    self.description = profile.description
                    self.website = profile.website
                    self.nfts = profile.nfts
                    self.likes = profile.likes
                    self.id = profile.id
                case .failure(let error):
                    print(error)
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func putProfileData(name: String, description: String, website: String, likes: [String]) {
        let networkClient = DefaultNetworkClient()
                
        let request = PutProfileRequest(
            name: name,
            description: description,
            website: website,
            likes: likes
        )
            
        networkClient.send(request: request, type: ProfileNetworkModel.self) { [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.avatarURL = URL(string: profile.avatar)
                    self.name = profile.name
                    self.description = profile.description
                    self.website = profile.website
                    self.nfts = profile.nfts
                    self.likes = profile.likes
                    self.id = profile.id
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
