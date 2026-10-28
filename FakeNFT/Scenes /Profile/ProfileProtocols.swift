import Foundation

// То, что Presenter может сказать View
protocol ProfileViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showProfile(_ profile: Profile)
    func showError(message: String)
    func navigateToMyNFTs()
    func navigateToFavorites()
}

// То, что View может сказать Presenter
protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewProtocol? { get set }
    func viewDidLoad()
    func didTapMyNFTs()
    func didTapFavorites()
    func didTapWebsite(urlString: String?)
}
