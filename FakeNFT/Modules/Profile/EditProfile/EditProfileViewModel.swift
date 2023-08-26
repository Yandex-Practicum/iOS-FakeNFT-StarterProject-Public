import UIKit

protocol EditProfileViewModelProtocol: AnyObject {
    var profile: ProfileModel? { get set }
    var urlString: String? { get set }
    var addedURL: (() -> Void)? { get set }
    var error: Error? { get }
    var avatarAlert: AlertModel { get }
    var wrongAlert: AlertModel { get }
    
    func updateProfile(profile: ProfileModel?)
    func updateAvatar()
    func showAlert(_ model: AlertModel) -> UIAlertController
    func isCheckCorrectURL() -> Bool
}

final class EditProfileViewModel: EditProfileViewModelProtocol {
    let avatarAlert = AlertModel(
        title: "Загрузить изображение",
        message: "Укажите ссылку на аватар",
        textField: true,
        placeholder: "Введите ссылку:",
        buttonText: "Ок",
        styleAction: .default
    )
    
    let wrongAlert = AlertModel(
        title: "Неверная ссылка",
        message: "Проверьте формат ссылки",
        textField: false,
        placeholder: "",
        buttonText: "Ок",
        styleAction: .cancel)
    
    private var networkClient: NetworkClient
    var addedURL: (() -> Void)?
    
    var urlString: String? {
        didSet {
            addedURL?()
        }
    }
    
    var profile: ProfileModel?
    private(set) var error: Error?
    
    init(networkClient: NetworkClient, profile: ProfileModel) {
        self.networkClient = networkClient
        self.profile = profile
    }
    
    func updateProfile(profile: ProfileModel?) {
        let request = ProfileRequest(httpMethod: .put, dto: profile)
        networkClient.send(request: request, type: ProfileModel.self) { _ in
            return
        }
    }
    
    func updateAvatar() {
        profile?.avatar = urlString ?? ""
        updateProfile(profile: profile)
    }
    
    func showAlert(_ model: AlertModel) -> UIAlertController {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        var action = UIAlertAction()
        
        if model.textField{
            alert.addTextField {textField in
                textField.placeholder = model.placeholder
            }
            
            action = UIAlertAction(
                title: model.buttonText,
                style: model.styleAction
            ){ [weak self] _ in
                guard
                    let self = self,
                    let textField = alert.textFields?[0],
                    let updateURL = textField.text
                else { return }
                self.urlString = updateURL
                alert.dismiss(animated: true)
            }
        } else {
            action = UIAlertAction(
                title: model.buttonText,
                style: model.styleAction
            ){ _ in
                alert.dismiss(animated: true)
            }
        }
        
        alert.addAction(action)
        return alert
    }
    
    func isCheckCorrectURL() -> Bool {
        let url = URL(string: urlString ?? "")
        guard let url = url else {return false}
        if UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
}
