import UIKit.UIImage

final class NFTCartCellViewModelFactory {
    static func makeNFTCartCellViewModel(
        id: String,
        name: String,
        image: UIImage?,
        rating: Int,
        price: Double
    ) -> NFTCartCellViewModel {
        return NFTCartCellViewModel(
            id: id,
            name: name,
            image: image,
            rating: rating,
            price: price
        )
    }
}
