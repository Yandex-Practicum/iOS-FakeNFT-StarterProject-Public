import UIKit

final class CartPlaceholderView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CART_PLACEHOLDER_LABEL_TEXT".localized
        label.font = .getFont(style: .bold, size: 17)
        label.textColor = .appBlack
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CartPlaceholderView {
    func configure() {
        self.backgroundColor = .appWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.addSubview(self.label)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
