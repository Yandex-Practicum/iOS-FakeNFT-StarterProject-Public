//
//  NFTsFactory.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 28.07.2023.
//

import UIKit

struct NFTsFactory {
    static func create() -> UINavigationController {
        let model = NFTsViewModelImpl()
        let vc = NFTsViewController(viewModel: model)
        return UINavigationController(rootViewController: vc)
    }
}
