import UIKit

final class ViewControllerFactory {
    func makeWebView(url: URL) -> WebViewViewController {
        let controller = WebViewViewController(url: url)
        return controller
    }

    func makeUserNFTViewController(nftList: [String]) -> UserNFTViewController {
        return UserNFTViewController(nftList: nftList,
                                     viewModel: UserNFTViewModel(nftService: NFTServiceProfile.shared))
    }

    func makeFavoritesNFTViewController(nftList: [String]) -> FavoritesNFTViewController {
        return FavoritesNFTViewController(nftList: nftList,
                                          viewModel: FavoritesNFTViewModel(nftService: NFTServiceProfile.shared,
                                                                           profileService: ProfileService.shared))
    }

    func makeEditingViewController() -> EditingViewController {
        return EditingViewController(viewModel: EditingViewModel(profileService: ProfileService.shared))
    }
}
