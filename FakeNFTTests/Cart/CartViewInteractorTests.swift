@testable import FakeNFT
import XCTest

final class CartViewInteractorTests: XCTestCase {
    private let nftService = NFTNetworkCartServiceSpy()
    private let orderService = OrderServiceSpy()
    private let imageLoadingService = ImageLoadingServiceSpy()

    func testCartViewInteractorFetchOrderSuccess() {
        let interactor = CartViewInteractor(
            nftService: self.nftService,
            orderService: self.orderService,
            imageLoadingService: self.imageLoadingService
        )

        self.orderService.neededRequestResult = .success

        let expectation = self.expectation(description: "Loading order")

        let onSuccess: LoadingCompletionBlock<CartViewModel.ViewState> = { state in
            if case .loaded = state {
                expectation.fulfill()
            }
        }
        let onFailure: LoadingFailureCompletionBlock = { _ in }

        interactor.fetchOrder(
            with: "1",
            onSuccess: onSuccess,
            onFailure: onFailure
        )

        self.waitForExpectations(timeout: 1)
        XCTAssertTrue(orderService.didFetchOrderCalled)
    }

    func testCartViewInteractorFetchOrderFailure() {
        let interactor = CartViewInteractor(
            nftService: self.nftService,
            orderService: self.orderService,
            imageLoadingService: self.imageLoadingService
        )

        self.orderService.neededRequestResult = .failure

        let expectation = self.expectation(description: "Loading order")

        let onSuccess: LoadingCompletionBlock<CartViewModel.ViewState> = { _ in }
        let onFailure: LoadingFailureCompletionBlock = { error in
            if error as? OrderServiceSpy.TestError != nil {
                expectation.fulfill()
            }
        }

        interactor.fetchOrder(
            with: "1",
            onSuccess: onSuccess,
            onFailure: onFailure
        )

        self.waitForExpectations(timeout: 1)
        XCTAssertTrue(orderService.didFetchOrderCalled)
    }
}
