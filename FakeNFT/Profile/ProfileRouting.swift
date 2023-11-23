import UIKit

protocol ProfileRouting {
    func routeToEditingViewController(viewModel: ProfileViewModelProtocol)
    func routeToWebView(url: URL)
    func routeToUserNFT()
    func routeToFavoritesNFT()
}

class ProfileRouter: ProfileRouting {
    private let factory = ViewControllerFactory()
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func routeToUserNFT() {
        let destinationVC = factory.makeUserNFTViewController()
        pushController(destinationVC)
    }

    func routeToFavoritesNFT() {
        let destinationVC = factory.makeFavoritesNFTViewController()
        pushController(destinationVC)
    }

    func routeToEditingViewController(viewModel: ProfileViewModelProtocol) {
        let editingViewController = factory.makeEditingViewController(viewModel: viewModel)
        presentController(editingViewController)
    }

    func routeToWebView(url: URL) {
        let webView = ViewControllerFactory().makeWebView(url: url)
        pushController(webView)
    }

    private func pushController(_ controller: UIViewController) {
        controller.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }

    private func presentController(_ controller: UIViewController) {
        controller.hidesBottomBarWhenPushed = true
        viewController?.present(controller, animated: true)
    }
}
