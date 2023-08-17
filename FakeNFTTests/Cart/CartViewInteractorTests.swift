@testable import FakeNFT
import XCTest

final class CartViewInteractorTests: XCTestCase {
    func testCartViewInteractorFetchOrder() {
        let nftService = NFTNetworkCartServiceSpy()
        let orderService = OrderServiceSpy()
        let imageLoadingService = ImageLoadingServiceSpy()

        let interactor = CartViewInteractor(
            nftService: nftService,
            orderService: orderService,
            imageLoadingService: imageLoadingService
        )

        let expectation = self.expectation(description: "Loading order")

        let onSuccess: LoadingCompletionBlock<CartViewModel.ViewState> = { state in
            if case .loaded(_, _) = state {
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
}
