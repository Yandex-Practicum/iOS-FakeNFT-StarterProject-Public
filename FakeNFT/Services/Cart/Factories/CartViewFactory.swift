//
//  CartViewFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 04.08.2023.
//

import Foundation

struct CartViewFactory {
    static func create() -> CartViewController {
        let networkClient = DefaultNetworkClient()

        let orderService = OrderService(networkClient: networkClient)
        let nftService = NFTNetworkServiceImpl(networkClient: networkClient)
        let imageLoadingService = ImageLoadingService()

        let cartViewInteractor = CartViewInteractor(
            nftService: nftService,
            orderService: orderService,
            imageLoadingService: imageLoadingService
        )

        let viewModel = CartViewModel(intercator: cartViewInteractor)

        let tableViewHelper = CartTableViewHelper()
        let viewController = CartViewController(viewModel: viewModel, tableViewHelper: tableViewHelper)
        return viewController
    }
}
