//
//  NFTDetailsFactory.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

struct NFTDetailsFactory {
    static func create(_ details: NFTDetails) -> UIViewController {
        let storage = NFtStorageServiceImpl()
        let viewModel = NFTDetailsViewModelImpl(nftstorageService: storage, details: details)
        let viewController = NFTDetailsViewController(viewModel: viewModel)
        return viewController
    }
}

