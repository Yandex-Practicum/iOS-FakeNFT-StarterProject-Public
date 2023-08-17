import UIKit.UIImage

public final class NFTCartCellViewModelFactory {
    public static func makeNFTCartCellViewModel(
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
