import Kingfisher
import UIKit

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Public properties
    weak var view: ProfileViewControllerProtocol?
    weak var networkClient: ProfileNetworkClientProtocol?
    
    private var currentProfileResponseModel: ProfileResponseModel?
    private var currentProfileEditModel: EditableProfileModel?
    
    // MARK: - Private properties
    func viewDidLoad() {
        UIBlockingProgressHUD.show()
        view?.activityIndicatorAnimation(inProcess: true)
        networkClient?.getDecodedProfile()
    }
    
    func getEditableProfile() -> EditableProfileModel? {
        currentProfileEditModel
    }
    
    func getCurrentProfileResponse() -> ProfileResponseModel? {
        currentProfileResponseModel
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


// MARK: - Extension ProfilePresenterNetworkProtocol
extension ProfileViewPresenter: ProfilePresenterNetworkProtocol {
    func getProfile(with data: ProfileResponseModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentProfileResponseModel = data
            
            self.view?.setTextForLabels(from: data)
            self.view?.activityIndicatorAnimation(inProcess: true)
            
            let urlString = data.avatar
            guard let url = URL(string: urlString) else {
                self.view?.activityIndicatorAnimation(inProcess: false)
                return
            }
            
            self.view?.setImageForPhotoView(.userpick ?? UIImage())
            KingfisherManager.shared.retrieveImage(with: url){ result in
                switch result {
                case .success(let result):
                    self.currentProfileResponseModel = data
                    self.currentProfileEditModel = self.convertResponse(
                        model: data,
                        image: result.image
                    )
                    self.view?.setImageForPhotoView(result.image)
                    self.view?.activityIndicatorAnimation(inProcess: false)
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    self.view?.setImageForPhotoView(.userpick ?? UIImage())
                    self.view?.activityIndicatorAnimation(inProcess: false)
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    func updateProfile(with data: ProfileResponseModel) {
        UIBlockingProgressHUD.show()
        networkClient?.updateProfile(with: data) { result in
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.networkClient?.getDecodedProfile()
                }
            case .failure(let error):
                print("Ошибка при обновлении профиля: \(error)")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
