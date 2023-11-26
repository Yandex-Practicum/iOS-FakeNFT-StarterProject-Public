import UIKit

final class ViewControllerFactory {
    func makeWebView(url: URL) -> WebViewViewController {
        let controller = WebViewViewController(url: url)
        
        return controller
    }

    func makeUserNFTViewController(nftList: [String]) -> UserNFTViewController {
        let userNFTViewController = UserNFTViewController(nftList: nftList,
                                                          viewModel: UserNFTViewModel(model: UserNFTModel()))
        return userNFTViewController
    }

    func makeFavoritesNFTViewController() -> FavoritesNFTViewController {
        return FavoritesNFTViewController()
    }

    func makeEditingViewController(viewModel: ProfileViewModelProtocol) -> EditingViewController {
        return EditingViewController(viewModel: viewModel as! EditingViewModelProtocol)
    }
}
