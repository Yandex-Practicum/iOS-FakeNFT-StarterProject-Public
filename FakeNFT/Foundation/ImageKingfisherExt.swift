import Kingfisher
import UIKit

extension UIImageView {
    func loadImage(url: URL, cornerRadius: CGFloat) {
        self.kf.setImage(
            with: url,
            options: [.cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
}
