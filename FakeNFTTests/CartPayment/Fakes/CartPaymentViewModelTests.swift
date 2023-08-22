@testable import FakeNFT
import XCTest

final class CartPaymentViewModelTests: XCTestCase {
    func testCartPaymentViewModelFetchCurrencies() {
        let interactor = CartPaymentViewInteractorSpy()
        let viewModel = CartPaymentViewModel(orderId: "1", interactor: interactor)

        let expectedCurrencies = interactor.currencies

        viewModel.fetchCurrencies()

        XCTAssertTrue(interactor.didFetchCurrenciesCalled)
        XCTAssertTrue(viewModel.currencies.value == expectedCurrencies)
    }

    func testCartPaymentViewModelPurchase() {
        let interactor = CartPaymentViewInteractorSpy()
        let viewModel = CartPaymentViewModel(orderId: "1", interactor: interactor)

        viewModel.selectedCurrencyId.value = "1"
        viewModel.purсhase()

        XCTAssertTrue(interactor.didPurchaseCalled)
        XCTAssertTrue(viewModel.purchaseState.value == .success)
    }
}
