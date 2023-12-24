
import Foundation
  
protocol ProfileViewControllerPresenterProtocol: AnyObject{
    var profileModelUI: ProfileModelUI? { get }
    func fetchProfile()
    func convertInUIModel(profileNetworkModel: ProfileModelNetwork)
}

final class ProfileViewControllerPresenter: ProfileViewControllerPresenterProtocol {
    
    private let profileService: ProfileServiceProtocol
    private weak var delegate: ProfileViewContrillerDelegate?
    private(set) var profileModelUI: ProfileModelUI? = nil
    
    init(profileService: ProfileServiceProtocol, delegate: ProfileViewContrillerDelegate) {
        self.profileService = profileService
        self.delegate = delegate
    }
    
    func fetchProfile() {
        delegate?.showLoading()
        profileService.getProfile() {[weak self] result in
            switch result {
            case .success(let profileNetwork):
                self?.delegate?.hideLoading()
                self?.convertInUIModel(profileNetworkModel: profileNetwork)
            case .failure(let error) :
                self?.delegate?.hideLoading()
                print(error.localizedDescription)
            }
        }
    }

    func convertInUIModel(profileNetworkModel: ProfileModelNetwork) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            
            var imageData: Data? = nil
            if let urlStr = profileNetworkModel.avatar,
                let url = URL(string: urlStr) {
                imageData = try? Data(contentsOf: url)
            }
            let profileModelUI = ProfileModelUI(
                id: profileNetworkModel.id,
                name: profileNetworkModel.name,
                avatar: imageData,
                urlAvatar: profileNetworkModel.avatar,
                description: profileNetworkModel.description,
                website: profileNetworkModel.website,
                nfts: profileNetworkModel.nfts,
                likes: profileNetworkModel.likes
            )
            self?.profileModelUI = profileModelUI
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.updateUI()
            }
        }

    }

}
