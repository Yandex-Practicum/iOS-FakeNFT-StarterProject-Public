import Foundation
import Kingfisher

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
}

protocol ProfilePresenterNetworkProtocol: AnyObject {
    func getData(for profile: ProfileModel)
}


final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Public properties
    weak var view: ProfileViewControllerProtocol?
    weak var networkClient: ProfileNetworkClientProtocol?
    
    // MARK: - Private properties
    
    func viewDidLoad() {
        view?.activityIndicatorAnimation(inProcess: true)
        networkClient?.getDecodedProfile()
    }
}


extension ProfileViewPresenter: ProfilePresenterNetworkProtocol {
    func getData(for profile: ProfileModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.activityIndicatorAnimation(inProcess: true)
            
            let urlString = profile.avatar
            guard let url = URL(string: urlString) else {
                self.view?.activityIndicatorAnimation(inProcess: false)
                return
            }
            KingfisherManager.shared.retrieveImage(with: url){ result in
                switch result {
                case .success(let result):
                    self.view?.setImageForPhotoView(result.image)
                    self.view?.activityIndicatorAnimation(inProcess: false)
                case .failure:
                    self.view?.activityIndicatorAnimation(inProcess: false)
                }
            }
        }
    }
}
