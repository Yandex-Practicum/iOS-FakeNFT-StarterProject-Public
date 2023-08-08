import UIKit

// MARK: - ProfileViewControllerProtocol
protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func activityIndicatorAnimation(inProcess: Bool)
    func userInteraction(isActive: Bool)
    func setImageForPhotoView(_ image: UIImage)
    func setTextForLabels(from profile: ProfileResponseModel)
}


// MARK: - ProfileViewPresenterProtocol
protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func getEditableProfile() -> EditableProfileModel?
}


// MARK: - ProfilePresenterNetworkProtocol
protocol ProfilePresenterNetworkProtocol: AnyObject {
    func getData(for profile: ProfileResponseModel)
}


// MARK: - ProfileNetworkClientProtocol
protocol ProfileNetworkClientProtocol: AnyObject {
    func getDecodedProfile()
}


// MARK: - ProfileViewDelegate
protocol ProfileViewDelegate: AnyObject {
    func sendNewProfile(_ profile: ProfileResponseModel)
}
