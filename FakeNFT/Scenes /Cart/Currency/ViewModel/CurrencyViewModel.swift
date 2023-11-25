import Foundation

protocol CurrencyViewModelProtocol {
    var onDataUpdate: (() -> Void)? { get set }
    var onErrorResult: (() -> Void)? { get set }
    var onSuccessResult: (() -> Void)? { get set }
    var onDataErrorResult: (() -> Void)? { get set }

    var currencies: [CurrencyModel] { get }
    var selectedCurrencyID: String? { get }

    func loadData()
    func getPaymentResult(with id: String)
    func selectCurrency(at indexPath: IndexPath)
}

final class CurrencyViewModel: CurrencyViewModelProtocol {
    let servicesAssembly: ServicesAssembly

    var onDataUpdate: (() -> Void)? {
        didSet {
            onDataUpdate?()
        }
    }

    var onErrorResult: (() -> Void)?
    var onSuccessResult: (() -> Void)?
    var onDataErrorResult: (() -> Void)?

    private (set) var currencies: [CurrencyModel] = []
    private (set) var selectedCurrencyID: String?

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func loadData() {
        servicesAssembly.currencyService.loadCurrencies { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let currencies):
                    self.currencies = currencies
                    self.onDataUpdate?()
                case .failure:
                    self.onDataErrorResult?()
                }
            }
        }
    }

    func getPaymentResult(with id: String) {
        servicesAssembly.currencyService.getPaymentResult(currencyId: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let payment):
                self.handlePaymentResult(payment)
            case .failure:
                self.onErrorResult?()
            }
        }
    }

    func selectCurrency(at indexPath: IndexPath) {
        selectedCurrencyID = currencies[indexPath.row].id
    }

    private func clearCart() {
        servicesAssembly.cartService.deleteNftFromCart(cartId: "1", nfts: []) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    return
                case .failure:
                    self.onDataErrorResult?()
                }
            }
        }
    }

    private func handlePaymentResult(_ payment: PaymentModel) {
        guard payment.success else {
            self.onErrorResult?()
            return
        }
        self.onSuccessResult?()
        self.clearCart()
    }
}
