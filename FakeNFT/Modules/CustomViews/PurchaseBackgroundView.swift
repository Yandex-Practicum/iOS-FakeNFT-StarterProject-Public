import UIKit

final class PurchaseBackgroundView: UIView {
    private enum Constants {
        static let cornerRadius: CGFloat = 12
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PurchaseBackgroundView {
    func configure() {
        self.backgroundColor = .appLightGray
        self.layer.masksToBounds = true
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
