import UIKit

// MARK: - ProfileViewControllerProtocol

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func activityIndicatorAnimation(inProcess: Bool)
    func setImageForPhotoView(_ image: UIImage)
    func setTextForLabels(from profile: ProfileResponseModel)
    func showNetworkErrorAlert(with error: Error)
}

// MARK: - ProfileViewPresenterProtocol

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    var editableProfile: EditableProfileModel? { get }
    var currentProfileResponse: ProfileResponseModel? { get }
    var myNFTs: [String] { get }
    func viewWillAppear()
    func updateProfile(with data: ProfileResponseModel)
}

// MARK: - ProfilePresenterNetworkProtocol

protocol ProfilePresenterNetworkProtocol: AnyObject {
    func getProfile(with data: ProfileResponseModel)
    func updateProfile(with data: ProfileResponseModel)
    func showAlert(with error: Error)
}

// MARK: - ProfileNetworkClientProtocol

protocol ProfileNetworkClientProtocol: AnyObject {
    func getDecodedProfile()
    func updateProfile(with data: ProfileResponseModel, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - ProfileViewDelegate

protocol ProfileViewDelegate: AnyObject {
    func sendNewProfile(_ profile: ProfileResponseModel)
}
