import UIKit.UIImage

struct CurrencyViewModelFactory {
    static func makeCurrencyCellViewModel(
        id: String,
        title: String,
        name: String,
        image: UIImage
    ) -> CurrencyCellViewModel {
        return CurrencyCellViewModel(id: id, title: title, name: name, image: image)
    }
}
