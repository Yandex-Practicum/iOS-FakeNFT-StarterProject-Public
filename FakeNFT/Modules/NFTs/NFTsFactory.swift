//
//  NFTsFactory.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 28.07.2023.
//

import UIKit

struct NFTsFactory {
    static func create(
        nftService: NFTNetworkService
    ) -> UINavigationController {
        let viewModel = NFTsViewModelImpl(networkService: nftService)
        let viewController = NFTsViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)

        return navigationController
    }
}
