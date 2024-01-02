
import Foundation
  
protocol ProfileViewControllerPresenterProtocol: AnyObject{
    var profileModelUI: ProfileModelUI? { get set }
    var delegate: ProfileViewContrillerDelegate? { get set }
    var profileService: ProfileServiceProtocol { get }
    var servicesAssembly: ServicesAssembly {get}
    func fetchProfile()
    func convertInUIModel(profileNetworkModel: ProfileModelNetwork)
}

final class ProfileViewControllerPresenter: ProfileViewControllerPresenterProtocol {
    
    // TODO: Сервер возвращает пустой массив
    private let mockMyIDNFT = ["739e293c-1067-43e5-8f1d-4377e744ddde",
                               "77c9aa30-f07a-4bed-886b-dd41051fade2",
                               "ca34d35a-4507-47d9-9312-5ea7053994c0"]
    
    let profileService: ProfileServiceProtocol
    let servicesAssembly: ServicesAssembly
    weak var delegate: ProfileViewContrillerDelegate?
    var profileModelUI: ProfileModelUI? = nil
    
    init(servicesAssembly: ServicesAssembly) {
        self.profileService = servicesAssembly.profileService
        self.servicesAssembly = servicesAssembly
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
                //nfts: profileNetworkModel.nfts,
                nfts: self?.mockMyIDNFT ?? [],           // TODO:
                likes: profileNetworkModel.likes
            )
            self?.profileModelUI = profileModelUI
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.updateUI()
            }
        }

    }

}
