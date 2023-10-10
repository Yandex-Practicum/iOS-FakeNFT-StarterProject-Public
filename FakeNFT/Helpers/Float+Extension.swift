import Foundation

extension Float {
    var ethCurrency: String {
        let formater = NumberFormatter()
        formater.numberStyle = .currency
        formater.currencySymbol = "ETH"
        return formater.string(from: NSNumber(value: self)) ?? ""
    }
}
