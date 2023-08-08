//
//  CartPaymentViewFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import Foundation

struct CartPaymentViewFactory {
    private let orderId: String

    private let currenciesService: CurrenciesServiceProtocol
    private let imageLoadingService: ImageLoadingServiceProtocol
    private let orderPaymentService: OrderPaymentServiceProtocol

    init(
        orderId: String,
        currenciesService: CurrenciesServiceProtocol,
        imageLoadingService: ImageLoadingServiceProtocol,
        orderPaymentService: OrderPaymentServiceProtocol
    ) {
        self.orderId = orderId
        self.currenciesService = currenciesService
        self.imageLoadingService = imageLoadingService
        self.orderPaymentService = orderPaymentService
    }

    func create() -> CartPaymentViewController {
        let collectionViewHelper = CartPaymentCollectionViewHelper()
        let router = CartPaymentRouter()

        let interactor = CartPaymentViewInteractor(
            currenciesService: self.currenciesService,
            imageLoadingService: self.imageLoadingService,
            orderPaymentService: self.orderPaymentService
        )

        let viewModel = CartPaymentViewModel(orderId: self.orderId, interactor: interactor)

        let cartPaymentViewController = CartPaymentViewController(
            collectionViewHelper: collectionViewHelper,
            viewModel: viewModel,
            router: router
        )

        cartPaymentViewController.navigationItem.backButtonTitle = ""
        cartPaymentViewController.hidesBottomBarWhenPushed = true

        return cartPaymentViewController
    }
}
