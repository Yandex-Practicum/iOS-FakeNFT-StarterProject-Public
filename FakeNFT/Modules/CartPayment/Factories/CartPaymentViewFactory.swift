import Foundation

struct CartPaymentViewFactory {
    static func create(
        orderId: String,
        currenciesService: CurrenciesServiceProtocol,
        imageLoadingService: ImageLoadingServiceProtocol,
        orderPaymentService: OrderPaymentServiceProtocol
    ) -> CartPaymentViewController {
        let collectionViewHelper = CartPaymentCollectionViewHelper()
        let router = CartPaymentRouter()

        let interactor = CartPaymentViewInteractor(
            currenciesService: currenciesService,
            imageLoadingService: imageLoadingService,
            orderPaymentService: orderPaymentService
        )

        let viewModel = CartPaymentViewModel(orderId: orderId, interactor: interactor)

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
