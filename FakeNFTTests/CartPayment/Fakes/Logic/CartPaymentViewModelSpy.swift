import Foundation
import FakeNFT

final class CartPaymentViewModelSpy {
    var didFetchCurrenciesCalled = false
    var didPurchaseCalled = false

    var neededPurchaseState: CartPaymentViewModel.PurchaseState = .success

    var currencies: FakeNFT.Box<FakeNFT.CurrenciesViewModel> = Box([])
    var cartPaymentViewState: FakeNFT.Box<FakeNFT.CartPaymentViewModel.ViewState> = Box(.loading)
    var purchaseState: FakeNFT.Box<FakeNFT.CartPaymentViewModel.PurchaseState> = Box(.didNotHappen)
    var error: FakeNFT.Box<Error?> = Box(nil)
    var selectedCurrencyId: FakeNFT.Box<String?> = Box(nil)
}

// MARK: - CartPaymentViewModelProtocol
extension CartPaymentViewModelSpy: CartPaymentViewModelProtocol {
    func fetchCurrencies() {
        self.didFetchCurrenciesCalled = true
        self.currencies.value = [CurrencyCellViewModel(id: "123", title: "123", name: "123", image: nil)]
    }

    func purсhase() {
        self.didPurchaseCalled = true
        self.purchaseState.value = self.neededPurchaseState
    }
}
