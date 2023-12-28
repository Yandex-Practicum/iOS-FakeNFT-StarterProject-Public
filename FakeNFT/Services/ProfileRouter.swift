import UIKit

protocol ProfileRouting {
    func routeToEditingViewController()
    func routeToWebView(url: URL)
    func routeToUserNFT(nftList: [String])
    func routeToFavoritesNFT(nftList: [String])
}

class ProfileRouter: ProfileRouting {
    private let factory = ViewControllerFactory()
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToUserNFT(nftList: [String]) {
        let destinationVC = factory.makeUserNFTViewController(nftList: nftList)
        pushController(destinationVC)
    }
    
    func routeToFavoritesNFT(nftList: [String]) {
        let destinationVC = factory.makeFavoritesNFTViewController(nftList: nftList)
        pushController(destinationVC)
    }
    
    func routeToEditingViewController() {
        let editingViewController = factory.makeEditingViewController()
        presentController(editingViewController)
    }

    func routeToWebView(url: URL) {
        let webView = factory.makeWebView(url: url)
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
