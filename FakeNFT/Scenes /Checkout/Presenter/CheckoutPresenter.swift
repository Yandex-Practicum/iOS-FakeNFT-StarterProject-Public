import Foundation

class CheckoutPresenter {
    private weak var view: CheckoutView?
    private var currencies: [CurrencyModel] = [.init(id: "1", title: "jqwe", name: "qwe", image: ""), .init(id: "2", title: "113", name: ";psdsa", image: "")]
    private let currenciesService: CurrenciesService = CurrenciesService.shared
    private var selectedCurrencyId: String?
    
    init(view: CheckoutView) {
        self.view = view
//        view.showHud()
        
//        loadCurrencies()
        self.view?.updateCurrencies(currencies)
    }
    
    func makePayment() {
        // to do: make payment
        view?.displayPaymentResult(success: false)
        
    }

    func didSelectCurrency(id: String?) {
        selectedCurrencyId = id
    }
}
