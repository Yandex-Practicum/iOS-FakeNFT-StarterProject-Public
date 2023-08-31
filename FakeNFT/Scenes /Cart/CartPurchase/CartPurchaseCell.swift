import UIKit

final class CartPurchaseCell: UICollectionViewCell {
    static let identifier = "CartPurchaseCell"

    private let bitcoinView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.backgroundColor = UIColor(red: 0.969,
                                             green: 0.969,
                                             blue: 0.973,
                                             alpha: 1).cgColor
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Regular.size13
        label.textColor = .label
        label.textAlignment = .left
        label.text = "Bitcoin"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Regular.size13
        label.textColor = UIColor(red: 0.11, green: 0.624, blue: 0, alpha: 1)
        label.textAlignment = .left
        label.text = "BTC"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell() {
        addSubviews()
        setCostraints()
    }

    private func addSubviews() {
        addSubview(bitcoinView)
        addSubview(titleLabel)
        addSubview(currencyLabel)
        addSubview(currencyImageView)
    }

    private func setCostraints() {
        NSLayoutConstraint.activate([
            bitcoinView.topAnchor.constraint(equalTo: topAnchor),
            bitcoinView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bitcoinView.widthAnchor.constraint(equalToConstant: 168),
            bitcoinView.heightAnchor.constraint(equalToConstant: 46),
            titleLabel.topAnchor.constraint(equalTo: bitcoinView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            currencyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            currencyLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            currencyImageView.topAnchor.constraint(equalTo: bitcoinView.topAnchor, constant: 4),
            currencyImageView.leadingAnchor.constraint(equalTo: bitcoinView.leadingAnchor, constant: 12),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36),
            currencyImageView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}
