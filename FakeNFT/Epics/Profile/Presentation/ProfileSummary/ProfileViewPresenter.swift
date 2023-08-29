import Kingfisher
import UIKit

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - ProfileViewPresenterProtocol properties
    
    var editableProfile: EditableProfileModel? {
        return currentProfileEditModel
    }
    var currentProfileResponse: ProfileResponseModel? {
        return currentProfileResponseModel
    }
    var myNFTs: [String] {
        guard let currentProfileResponseModel = currentProfileResponseModel else { return [] }
        return currentProfileResponseModel.nfts
    }
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Public properties
    
    weak var networkClient: ProfileNetworkClientProtocol?
    
    // MARK: - Private properties
    
    private var currentProfileResponseModel: ProfileResponseModel?
    private var currentProfileEditModel: EditableProfileModel?
    
    // MARK: - ProfileViewPresenterProtocol
    
    func viewWillAppear() {
        ProfileNetworkService.shared.fetchProfile(id: "1")
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
    
    func getMyNFTs() -> [String] {
        guard let currentProfileResponseModel = currentProfileResponseModel else { return [] }
        return currentProfileResponseModel.nfts
    }
    
    // MARK: - Private properties
    
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
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.currentProfileResponseModel = data
                        self.currentProfileEditModel = self.convertResponse(
                            model: data,
                            image: result.image
                        )
                        self.view?.setImageForPhotoView(result.image)
                        self.view?.activityIndicatorAnimation(inProcess: false)
                        UIBlockingProgressHUD.dismiss()
                    }
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.view?.setImageForPhotoView(.userpick ?? UIImage())
                        self.view?.activityIndicatorAnimation(inProcess: false)
                        self.view?.showNetworkErrorAlert(with: error)
                        UIBlockingProgressHUD.dismiss()
                    }
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
                    UIBlockingProgressHUD.dismiss()
                    self.networkClient?.getDecodedProfile()
                }
            case .failure(let error):
                self.showAlert(with: error)
            }
        }
    }
    
    func showAlert(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            view?.showNetworkErrorAlert(with: error)
            UIBlockingProgressHUD.dismiss()
        }
    }
}
