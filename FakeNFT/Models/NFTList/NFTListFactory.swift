//
//  NFTListFactory.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

struct NFTListFactory {
    static func create() -> UINavigationController {
        let viewModel = NFTListViewModelImpl()
        let viewController = NFTListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
