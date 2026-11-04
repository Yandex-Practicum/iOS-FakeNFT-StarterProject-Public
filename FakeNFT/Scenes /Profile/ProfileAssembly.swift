import UIKit

final class ProfileAssembly {
    static func assemble() -> UIViewController {
        let presenter = ProfilePresenter()
        let viewController = ProfileViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
