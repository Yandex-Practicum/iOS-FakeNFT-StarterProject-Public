import Foundation
import FakeNFT

final class CartPaymentViewInteractorSpy: CartPaymentViewInteractorProtocol {
    var didFetchCurrenciesCalled = false
    var didPurchaseCalled = false

    let currencies = [
        CurrencyCellViewModel(id: "123", title: "123", name: "123", image: nil),
        CurrencyCellViewModel(id: "1234", title: "1234", name: "1234", image: nil),
    ]

    func fetchCurrencies(
        onSuccess: @escaping FakeNFT.LoadingCompletionBlock<FakeNFT.CartPaymentViewModel.ViewState>,
        onFailure: @escaping FakeNFT.LoadingFailureCompletionBlock
    ) {
        self.didFetchCurrenciesCalled = true
        onSuccess(.loaded(self.currencies))
    }

    func purchase(
        orderId: String,
        currencyId: String,
        onSuccess: @escaping FakeNFT.LoadingCompletionBlock<FakeNFT.CartPaymentViewModel.PurchaseState>,
        onFailure: @escaping FakeNFT.LoadingFailureCompletionBlock
    ) {
        self.didPurchaseCalled = true
        onSuccess(.success)
    }
}
