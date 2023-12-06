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
    
    }
// Создаем `EditingViewModel` с передачей зависимостей
func makeEditingViewModel() -> EditingViewModel {
    let profileService = ProfileService(networkClient: DefaultNetworkClient())
    return EditingViewModel(profileService: profileService)
}

// Создаем `EditingViewController` и передаем в него уже созданный `EditingViewModel`
func makeEditingViewController(with viewModel: EditingViewModel) -> EditingViewController {
    return EditingViewController(viewModel: viewModel)
}

let editingViewModel = makeEditingViewModel()
let editingViewController = makeEditingViewController(with: editingViewModel)
extension ViewControllerFactory {
    func makeEditingViewController() -> EditingViewController {
        let viewModel = EditingViewModel(profileService: ProfileService(networkClient: DefaultNetworkClient()))
        return EditingViewController(viewModel: viewModel)
    }
}
