import UIKit

final class FavoriteButton: UIButton {
    var nftID: String?
    
    var isFavorite: Bool = false {
        didSet {
            let image = self.isFavorite ? UIImage.Favourite.active : UIImage.Favourite.nonActive
            self.setImage(image, for: .normal)
        }
    }
}
