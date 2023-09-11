import UIKit

protocol PaymentViewModelProtocol {
    var currencies: [CurrencyModel] { get }
    func selectCurrency(with id: String)
    var currenciesObservable: Observable<[CurrencyModel]> { get }
    func didLoad()
}

final class PaymentViewModel: PaymentViewModelProtocol {
    @Observable
    private (set) var currencies: [CurrencyModel] = []
    
    private var selectedCurrency: CurrencyModel?
    
    var currenciesObservable: Observable<[CurrencyModel]> { $currencies }
    
    private let model: CartLoadServiceProtocol
    
    init(model: CartLoadServiceProtocol = CartLoadService()) {
        self.model = model
    }
    
    func didLoad() {
        model.fetchCurrencies { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                switch result {
                case let .success(currencies):
                    self.currencies = currencies
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    func startObserve() {
        didLoad()
    }
    
    func selectCurrency(with id: String) {
        self.selectedCurrency = currencies.first(where: { $0.id == id } )
    }
}
