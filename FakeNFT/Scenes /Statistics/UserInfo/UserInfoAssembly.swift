import UIKit

final class UserInfoAssembly {
    
    private let networkClient = DefaultNetworkClient()
    private let userInfoStorage = UserInfoStorage()
    
    private var userInfoService: UserInfoServiceProtocol {
        UserInfoService(
            networkClient: networkClient,
            storage: userInfoStorage
        )
    }
    
    func build(with input: String) -> UIViewController {
        let presenter = UserInfoPresenter(
            userID: input,
            service: userInfoService
        )
        let viewController = UserInfoViewController(presenter: presenter)
        presenter.view = viewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
