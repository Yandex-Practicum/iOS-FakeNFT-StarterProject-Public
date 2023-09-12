import UIKit

protocol PaymentViewModelProtocol {
    var currencies: [CurrencyModel] { get }
    var currenciesObservable: Observable<[CurrencyModel]> { get }
    var paymentStatusObservable: Observable<PaymentStatus> { get }
    func selectCurrency(with id: String)
    func didLoad()
    func makingPayment()
}

final class PaymentViewModel: PaymentViewModelProtocol {
    
    @Observable
    private (set) var currencies: [CurrencyModel] = []
    
    @Observable
    private (set) var paymentStatus: PaymentStatus = .notPay
    
    private var selectedCurrency: CurrencyModel?
    
    var currenciesObservable: Observable<[CurrencyModel]> { $currencies }
    var paymentStatusObservable: Observable<PaymentStatus> { $paymentStatus }
    
    private let model: CartLoadServiceProtocol
    
    init(model: CartLoadServiceProtocol = CartLoadService()) {
        self.model = model
    }
    
    func didLoad() {
        model.fetchCurrencies { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case let .success(currencies):
                    self.currencies = currencies
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    func selectCurrency(with id: String) {
        self.selectedCurrency = currencies.first(where: { $0.id == id } )
    }
    
    func makingPayment() {
        guard let id = selectedCurrency?.id else { return }
        model.sendingPaymentInfo(id: id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(payment):
                    print(payment)
                    self.paymentStatus = .pay
                case let .failure(error):
                    print(error)
                    self.paymentStatus = .notPay
                    self.selectedCurrency = nil
                }
            }
        }
    }
}
