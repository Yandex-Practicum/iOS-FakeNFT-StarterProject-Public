import UIKit

// MARK: - ProfileViewControllerProtocol

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func activityIndicatorAnimation(inProcess: Bool)
    func setImageForPhotoView(_ image: UIImage)
    func setTextForLabels(from profile: ProfileResponseModel)
}

// MARK: - ProfileViewPresenterProtocol

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func getEditableProfile() -> EditableProfileModel?
    func updateProfile(with data: ProfileResponseModel)
    func getCurrentProfileResponse() -> ProfileResponseModel?
    func getMyNFTs() -> [String]
}

// MARK: - ProfilePresenterNetworkProtocol

protocol ProfilePresenterNetworkProtocol: AnyObject {
    func getProfile(with data: ProfileResponseModel)
    func updateProfile(with data: ProfileResponseModel)
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
