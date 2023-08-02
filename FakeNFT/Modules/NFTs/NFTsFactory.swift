//
//  NFTsFactory.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 28.07.2023.
//

import UIKit

struct NFTsFactory {
    static func create() -> UINavigationController {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let networkClient = DefaultNetworkClient(decoder: decoder)
        let service = NFTNetworkServiceImpl(
            networkClient: networkClient
        )
        let model = NFTsViewModelImpl(networkService: service)

        return UINavigationController(
            rootViewController: NFTsViewController(viewModel: model)
        )
    }
}


