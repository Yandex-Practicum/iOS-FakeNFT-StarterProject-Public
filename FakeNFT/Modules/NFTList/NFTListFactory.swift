//
//  NFTListFactory.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

struct NFTListFactory {
    static func create() -> UINavigationController {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let networkClient = DefaultNetworkClient(decoder: decoder)
        let nftNetworkService = NFTNetworkServiceImpl(networkClient: networkClient)
        let viewModel = NFTListViewModelImpl(nftNetworkService: nftNetworkService)
        let vieController = NFTListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: vieController)
        return navigationController
    }
}
