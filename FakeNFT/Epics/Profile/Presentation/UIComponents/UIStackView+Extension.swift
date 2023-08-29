import UIKit

extension UIStackView {
    func setStarsInStack(with rating: String) {
        let rating = Int(rating) ?? 1
        for i in 1...5 {
            let image: UIImage? = i <= rating ? UIImage.yellowStar : UIImage.grayStar
            let imageView = UIImageView(image: image)
            addArrangedSubview(imageView)
        }
    }
}
