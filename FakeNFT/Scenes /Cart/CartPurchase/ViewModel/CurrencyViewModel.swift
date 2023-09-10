import Foundation

final class CurrencyViewModel {
    
    @Observable
    var currencies: [CurrencyModel] = []
    
    @Observable
    var isPaymentSuccesful: Bool = false
    
    private var selectedCurrency: CurrencyServerModel?
    private let model: CurrencyManager
    
    init(model: CurrencyManager) {
        self.model = model
    }
    
    func viewDidLoad(completion: @escaping () -> Void) {
        UIBlockingProgressHUD.show()
        model.fetchCurrencies { currencies in
            DispatchQueue.main.async {
                switch currencies {
                case .success(let currencies):
                    UIBlockingProgressHUD.dismiss()
                    let models = currencies.map(CurrencyModel.init(serverModel:))
                    self.currencies = models
                    completion()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    func sendGetPayment(selectedId: String, completion: @escaping (Bool) -> Void) {
        model.fetchCurrencyById(currencyId: selectedId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(let currency):
                    self?.model.getPayment(with: currency.id,
                                           completion: { [weak self] result in
                        switch result {
                        case .success(let payment):
                            self?.isPaymentSuccesful = payment.success
                            completion(payment.success)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    })
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
