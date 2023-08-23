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

        return UINavigationController(
            rootViewController: NFTsViewController(
                viewModel: NFTsViewModelImpl(
                    networkService: NFTNetworkServiceImpl(
                        networkClient: DefaultNetworkClient(decoder: decoder)
                    )
                )
            )
        )
    }
}
