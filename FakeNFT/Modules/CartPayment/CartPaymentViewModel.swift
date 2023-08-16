import Foundation

protocol CartPaymentViewModelProtocol {
    var currencies: Box<CurrenciesViewModel> { get }
    var cartPaymentViewState: Box<CartPaymentViewModel.ViewState> { get }
    var isPurchaseSuccessful: Box<CartPaymentViewModel.PurchaseState> { get }
    var error: Box<Error?> { get }
    var selectedCurrencyId: Box<String?> { get }

    func fetchCurrencies()
    func purсhase()
}

final class CartPaymentViewModel {
    enum PurchaseState {
        case success
        case failure
        case didNotHappen
    }

    let currencies = Box<CurrenciesViewModel>([])
    let cartPaymentViewState = Box<ViewState>(.loading)
    let isPurchaseSuccessful = Box<PurchaseState>(.didNotHappen)
    let error = Box<Error?>(nil)
    let selectedCurrencyId = Box<String?>(nil)

    private let orderId: String

    private lazy var successFetchCompletion: LoadingCompletionBlock<ViewState> = { [weak self] viewState in
        if case .loaded(let currencies) = viewState {
            guard let self = self, let currencies = currencies else { return }
            self.cartPaymentViewState.value = viewState
            self.currencies.value = currencies
        }
    }

    private lazy var purchaseCompletion: LoadingCompletionBlock<PurchaseState> = { [weak self] purchaseState in
        guard let self = self else { return }
        self.cartPaymentViewState.value = .loaded(nil)
        self.isPurchaseSuccessful.value = purchaseState
    }

    private lazy var failureCompletion: LoadingFailureCompletionBlock = { [weak self] error in
        guard let self = self else { return }
        self.error.value = error
        self.cartPaymentViewState.value = .empty
    }

    private let cartPaymentInteractor: CartPaymentViewInteractorProtocol

    init(orderId: String, interactor: CartPaymentViewInteractorProtocol) {
        self.orderId = orderId
        self.cartPaymentInteractor = interactor
    }
}

// MARK: - CartPaymentViewModelProtocol
extension CartPaymentViewModel: CartPaymentViewModelProtocol {
    func fetchCurrencies() {
        if self.cartPaymentViewState.value != .loading {
            self.cartPaymentViewState.value = .loading
        }

        self.cartPaymentInteractor.fetchCurrencies(
            onSuccess: self.successFetchCompletion,
            onFailure: self.failureCompletion
        )
    }

    func purсhase() {
        guard let selectedCurrencyId = self.selectedCurrencyId.value else { return }
        self.cartPaymentViewState.value = .loading
        self.cartPaymentInteractor.purchase(
            orderId: self.orderId,
            currencyId: selectedCurrencyId,
            onSuccess: self.purchaseCompletion,
            onFailure: self.failureCompletion
        )
    }
}
