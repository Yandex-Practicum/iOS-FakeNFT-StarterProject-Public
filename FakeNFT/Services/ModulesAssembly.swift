//
//  ModulesAssembly.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 12.07.2024.
//
//

import UIKit

final class CartService: CartControllerProtocol {
    var cart: [Nft] = []
    func addToCart(
        _ nft: Nft,
        completion: (
    () -> Void
        )?
    ) {

    }
    func removeFromCart(
        _ id: String,
        completion: (
    () -> Void
        )?
    ) {

    }
    func removeAll(
        completion: (
    () -> Void
        )?
    ) {

    }
    weak var delegate: CartControllerDelegate?
    private var _cart: [Nft] = []
}

protocol ModulesAssemblyProtocol: AnyObject {
    static func mainScreenBuilder() -> UIViewController
}

final class ModulesAssembly: ModulesAssemblyProtocol {

    static let shared = ModulesAssembly()

    static func mainScreenBuilder() -> UIViewController {
        let tabbarController = UITabBarController()

        let profileViewController = UINavigationController(
            rootViewController: Self.catalogScreenBuilder()
        )

        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(
                "Каталог",
                comment: ""
            ),
            image: Asset.Images.tabBarCatalog,
            tag: 0
        )

        tabbarController.viewControllers = [profileViewController]

        return tabbarController
    }

    static func catalogScreenBuilder() -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let dataProvider = CatalogDataProvider(
            networkClient: networkClient
        )
        let presenter = CatalogPresenter(
            dataProvider: dataProvider
        )
        let cartService = CartService()
        let catalogViewController = CatalogViewController(
            presenter: presenter,
            cartService: cartService
        )
        return catalogViewController
    }

    func сatalogСollection(nftModel: NFTCollection) -> UIViewController {
        let dataProvider = CollectionDataProvider(networkClient: DefaultNetworkClient())
        let presenter = CatalogСollectionPresenter(nftModel: nftModel, dataProvider: dataProvider, cartController: CartService())
        let viewController = CatalogСollectionViewController(presenter: presenter, das: nftModel)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

}
