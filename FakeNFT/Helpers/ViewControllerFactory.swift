import UIKit

final class ViewControllerFactory {
    func makeWebView(url: URL) -> WebViewViewController {
        let controller = WebViewViewController(url: url)
        return controller
    }
    
    func makeUserNFTViewController(nftList: [String]) -> UserNFTViewController {
        let viewModel = UserNFTViewModel(model: UserNFTModel(), nftList: nftList)
        let userNFTViewController = UserNFTViewController(viewModel: viewModel)
        return userNFTViewController
    }
    
    func makeFavoritesNFTViewController() -> FavoritesNFTViewController {
        return FavoritesNFTViewController()
    }
    
    func makeEditingViewController() -> EditingViewController {
        return EditingViewController(viewModel: EditingViewModel(profileService: ProfileService(networkClient: DefaultNetworkClient())))
    }
}
