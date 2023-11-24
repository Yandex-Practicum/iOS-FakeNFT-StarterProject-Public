import Foundation

final class CurrencyViewModel {
    let servicesAssembly: ServicesAssembly

    var onDataUpdate: (() -> Void)? {
        didSet {
            onDataUpdate?()
        }
    }

    var onErrorResult: (() -> Void)?
    var onSuccessResult: (() -> Void)?

    private (set) var currencies: [CurrencyModel] = []

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
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
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
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }

    private func clearCart() {
        servicesAssembly.cartService.deleteNftFromCart(cartId: "1", nfts: []) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    return
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
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
