import UIKit
import WebKit

protocol StatisticsNavigationProtocol {
    func goBack()
    func goToProfile(userID: String)
    func goToUserWebsite(url: URL)
    func goToUserNFTCollection(nftIDs: [String])
}

final class StatisticsNavigation: StatisticsNavigationProtocol {
    weak var navigationController: UINavigationController?

    private let networkClient = DefaultNetworkClient()

    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    func goToProfile(userID: String) {
        let profileViewController = assembleUserCardModule(userID: userID)
        navigationController?.pushViewController(profileViewController, animated: true)
    }

    func goToUserWebsite(url: URL) {
        let webKitViewController = assembleWKWebView(url: url)
        navigationController?.pushViewController(webKitViewController, animated: true)
    }

    func goToUserNFTCollection(nftIDs: [String]) {
        let collectionViewController = assembleUserCollectionModule(nftIDs: nftIDs)
        navigationController?.pushViewController(collectionViewController, animated: true)
    }
}

extension StatisticsNavigation {
    func assembleStatisticsModule() -> UIViewController {
        let model = StatisticsLoader(networkClient: networkClient)
        let viewModel = StatisticsViewModel(model: model, router: self)
        let view = StatisticsViewController(viewModel: viewModel)

        return view
    }

    private func assembleUserCardModule(userID: String) -> UIViewController {
        let model = StatisticsUserProfileModel(networkClient: networkClient)
        let viewModel = StatisticsUserProfileViewModel(id: userID, router: self, model: model)
        let view = StatisticsUserProfileViewController(viewModel: viewModel)

        return view
    }

    private func assembleUserCollectionModule(nftIDs: [String]) -> UIViewController {
        let model = StatisticsUserNFTCollectionModel(networkClient: networkClient)
        let viewModel = StatisticsUserNFTCollectionViewModel(
            model: model,
            router: self,
            nftIDs: nftIDs
        )
        let view = StatisticsUserNFTCollectionViewController(viewModel: viewModel)

        return view
    }

    private func assembleWKWebView(url: URL) -> UIViewController {
        WebViewController(url: url)
    }
}
