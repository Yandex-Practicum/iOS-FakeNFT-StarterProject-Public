import Foundation

final class CurrencyViewModel {
    let servicesAssembly: ServicesAssembly

    var onDataUpdate: (() -> Void)? {
        didSet {
            onDataUpdate?()
        }
    }

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
}
