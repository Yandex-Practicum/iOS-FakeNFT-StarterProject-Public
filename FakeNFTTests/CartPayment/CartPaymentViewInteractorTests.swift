@testable import FakeNFT
import XCTest

final class CartPaymentViewInteractorTests: XCTestCase {
    private let currenciesService = CurrenciesServiceSpy()
    private let imageLoadingService = ImageLoadingServiceSpy()
    private let orderService = OrderServiceSpy()

    func testCartPaymentViewInteractorFetchCurrenciesSuccess() {
        let interactor = CartPaymentViewInteractor(
            currenciesService: self.currenciesService,
            imageLoadingService: self.imageLoadingService,
            orderPaymentService: self.orderService
        )

        self.currenciesService.neededFetchStatus = .success

        let expectation = self.expectation(description: "Loading currencies")

        let onSuccess: LoadingCompletionBlock<CartPaymentViewModel.ViewState> = { state in
            if case .loaded = state {
                expectation.fulfill()
            }
        }
        let onFailure: LoadingFailureCompletionBlock = { _ in }

        interactor.fetchCurrencies(
            onSuccess: onSuccess,
            onFailure: onFailure
        )

        self.waitForExpectations(timeout: 1)
        XCTAssertTrue(currenciesService.didFetchCurrenciesCalled)
    }

    func testCartPaymentViewInteractorFetchCurrenciesFailure() {
        let interactor = CartPaymentViewInteractor(
            currenciesService: self.currenciesService,
            imageLoadingService: self.imageLoadingService,
            orderPaymentService: self.orderService
        )

        self.currenciesService.neededFetchStatus = .failure

        let expectation = self.expectation(description: "Loading currencies")

        let onSuccess: LoadingCompletionBlock<CartPaymentViewModel.ViewState> = { _ in }
        let onFailure: LoadingFailureCompletionBlock = { error in
            if let _ = error as? CurrenciesServiceSpy.TestError {
                expectation.fulfill()
            }
        }

        interactor.fetchCurrencies(
            onSuccess: onSuccess,
            onFailure: onFailure
        )

        self.waitForExpectations(timeout: 1)
        XCTAssertTrue(currenciesService.didFetchCurrenciesCalled)
    }
}
