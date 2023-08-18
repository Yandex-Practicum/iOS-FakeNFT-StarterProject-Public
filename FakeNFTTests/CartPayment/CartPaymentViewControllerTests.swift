@testable import FakeNFT
import XCTest

final class CartPaymentViewControllerTests: XCTestCase {
    func testCartPaymentViewControllerCallsFetchCurrencies() {
        let helper = CartPaymentCollectionViewHelper()
        let viewModel = CartPaymentViewModelSpy()
        let router = CartPaymentRouterSpy()

        let viewController = CartPaymentViewController(
            collectionViewHelper: helper,
            viewModel: viewModel,
            router: router
        )

        _ = viewController.view

        XCTAssertTrue(viewModel.didFetchCurrenciesCalled)
        XCTAssertTrue(!viewController.currencies.isEmpty)
    }

    func testCartPaymentViewControllerShowsPurchaseSuccessState() {
        let helper = CartPaymentCollectionViewHelper()
        let viewModel = CartPaymentViewModelSpy()
        let router = CartPaymentRouterSpy()

        let viewController = CartPaymentViewController(
            collectionViewHelper: helper,
            viewModel: viewModel,
            router: router
        )

        let expectedPaymentResultType: CartPaymentResultViewController.ResultType = .success

        _ = viewController.view

        viewModel.neededPurchaseState = .success
        viewModel.purсhase()

        XCTAssertTrue(viewModel.didPurchaseCalled)
        XCTAssertTrue(router.didShowPaymentResultCalled)
        XCTAssertTrue(router.recievedPaymentResultType == expectedPaymentResultType)
    }

    func testCartPaymentViewControllerShowsPurchaseFailureState() {
        let helper = CartPaymentCollectionViewHelper()
        let viewModel = CartPaymentViewModelSpy()
        let router = CartPaymentRouterSpy()

        let viewController = CartPaymentViewController(
            collectionViewHelper: helper,
            viewModel: viewModel,
            router: router
        )

        let expectedPaymentResultType: CartPaymentResultViewController.ResultType = .failure

        _ = viewController.view

        viewModel.neededPurchaseState = .failure
        viewModel.purсhase()

        XCTAssertTrue(viewModel.didPurchaseCalled)
        XCTAssertTrue(router.didShowPaymentResultCalled)
        XCTAssertTrue(router.recievedPaymentResultType == expectedPaymentResultType)
    }
}
