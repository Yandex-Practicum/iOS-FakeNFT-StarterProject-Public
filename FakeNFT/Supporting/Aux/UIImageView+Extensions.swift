import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(urlString: String?, placeholder: UIImage?, radius: Int?) {
        guard let url = URL(string: urlString ?? "") else { return }
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.processor(RoundCornerImageProcessor(cornerRadius: CGFloat(radius ?? 0)))])
    }
}
