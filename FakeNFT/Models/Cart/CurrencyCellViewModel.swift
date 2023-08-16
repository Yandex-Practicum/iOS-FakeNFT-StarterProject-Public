import UIKit.UIImage

struct CurrencyCellViewModel: Equatable {
    let id: String
    let title: String
    let name: String
    let image: UIImage?
}

typealias CurrenciesViewModel = [CurrencyCellViewModel]
