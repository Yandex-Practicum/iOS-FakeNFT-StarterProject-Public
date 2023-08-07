import Foundation
import Kingfisher
import UIKit

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func getEditableProfile() -> EditableProfileModel?
}

protocol ProfilePresenterNetworkProtocol: AnyObject {
    func getData(for profile: ProfileResponseModel)
}


final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Public properties
    weak var view: ProfileViewControllerProtocol?
    weak var networkClient: ProfileNetworkClientProtocol?
    
    private var currentProfileResponseModel: ProfileResponseModel?
    private var currentProfileEditModel: EditableProfileModel?
    
    // MARK: - Private properties
    func viewDidLoad() {
        view?.activityIndicatorAnimation(inProcess: true)
        view?.userInteraction(isActive: false)
        networkClient?.getDecodedProfile()
    }
    func getEditableProfile() -> EditableProfileModel? {
        currentProfileEditModel
    }
    private func convertResponse(model: ProfileResponseModel?, image: UIImage?) -> EditableProfileModel? {
        guard let model = model else {return nil}
        return EditableProfileModel(
            name: model.name,
            avatar: model.avatar,
            avatarImage: image,
            description: model.description,
            website: model.website,
            nfts: model.nfts,
            likes: model.likes,
            id: model.id
        )
    }
}


extension ProfileViewPresenter: ProfilePresenterNetworkProtocol {
    func getData(for profile: ProfileResponseModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentProfileResponseModel = profile
            
            self.view?.setTextForLabels(from: profile)
            self.view?.activityIndicatorAnimation(inProcess: true)
            self.view?.userInteraction(isActive: false)
            
            let urlString = profile.avatar
            guard let url = URL(string: urlString) else {
                self.view?.activityIndicatorAnimation(inProcess: false)
                self.view?.userInteraction(isActive: true)
                return
            }
            KingfisherManager.shared.retrieveImage(with: url){ result in
                switch result {
                case .success(let result):
                    self.currentProfileEditModel = self.convertResponse(
                        model: profile,
                        image: result.image
                    )
                    self.view?.setImageForPhotoView(result.image)
                    self.view?.activityIndicatorAnimation(inProcess: false)
                    self.view?.userInteraction(isActive: true)
                case .failure:
                    self.view?.activityIndicatorAnimation(inProcess: false)
                    self.view?.userInteraction(isActive: true)
                }
            }
        }
    }
}
