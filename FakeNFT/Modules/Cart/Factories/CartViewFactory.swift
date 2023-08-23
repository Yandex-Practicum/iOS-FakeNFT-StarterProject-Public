import Foundation

struct CartViewFactory {
    static func create(
        nftService: NFTNetworkCartService,
        orderService: OrderServiceProtocol,
        currenciesService: CurrenciesServiceProtocol,
        imageLoadingService: ImageLoadingServiceProtocol
    ) -> NavigationController {
        let networkClient = DefaultNetworkClient()
        let networkRequestSender = NetworkRequestSender(networkClient: networkClient)

        let orderService = OrderService(networkRequestSender: networkRequestSender)
        let nftService = NFTNetworkServiceImpl(networkClient: networkClient)
        let imageLoadingService = ImageLoadingService()

        let cartViewInteractor = CartViewInteractor(
            nftService: nftService,
            orderService: orderService,
            imageLoadingService: imageLoadingService
        )

        let orderSorter = CartOrderSorter()

        let viewModel = CartViewModel(intercator: cartViewInteractor, orderSorter: orderSorter)
        let tableViewHelper = CartTableViewHelper()

        let currenciesService = CurrenciesService(networkRequestSender: networkRequestSender)
        let router = CartViewRouter(
            currenciesService: currenciesService,
            imageLoadingService: imageLoadingService,
            orderPaymentService: orderService
        )

        let viewController = CartViewController(
            viewModel: viewModel,
            tableViewHelper: tableViewHelper,
            router: router
        )

        let navigationController = NavigationController(rootViewController: viewController)
        return navigationController
    }
}
