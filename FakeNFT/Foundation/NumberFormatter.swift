import Foundation

extension NumberFormatter {
    static var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.currencyDecimalSeparator = ","
        return formatter
    }()
}
