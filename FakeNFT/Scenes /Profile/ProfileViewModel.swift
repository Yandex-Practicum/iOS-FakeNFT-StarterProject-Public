import UIKit

final class ProfileViewModel {
    
    var onChange: (() -> Void)?
    
    private weak var viewController: UIViewController?
    
    private(set) var userImageURL: URL? {
        didSet {
            onChange?()
        }
    }
    
    private(set) var userName: String? {
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
    
    init(viewController: UIViewController){
        self.viewController = viewController
        getProfileData()
    }
    
    func getProfileData() {
        UIBlockingProgressHUD.show()
        let networkClient = DefaultNetworkClient()
        
        networkClient.send(request: ProfileRequest(), type: ProfileNetworkModel.self) { [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.userImageURL = URL(string: profile.avatar)
                    self.userName = profile.name
                    self.description = profile.description
                    self.website = profile.website
                    self.nfts = profile.nfts
                    self.likes = profile.likes
                case .failure(let error):
                    print(error)
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
}
