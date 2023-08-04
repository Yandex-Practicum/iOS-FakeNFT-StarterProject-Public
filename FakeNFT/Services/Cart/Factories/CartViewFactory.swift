//
//  CartViewFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 04.08.2023.
//

import Foundation

struct CartViewFactory {
    static func create() -> CartViewController {
        let cartCellViewModelFactory = NFTCartCellViewModelFactory()
        let imageLoadingService = ImageLoadingService()
        let networkClient = DefaultNetworkClient()

        let orderService = OrderService(networkClient: networkClient)

        let viewModel = CartViewModel(orderService: orderService)
        let tableViewHelper = CartTableViewHelper()
        let viewController = CartViewController(viewModel: viewModel, tableViewHelper: tableViewHelper)
        return viewController
    }
}
