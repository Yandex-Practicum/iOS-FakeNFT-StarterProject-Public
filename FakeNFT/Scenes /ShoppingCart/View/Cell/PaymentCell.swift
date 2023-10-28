import UIKit

class PaymentCell: UICollectionViewCell {
    static let reuseIdentifier = "PaymentCell"

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NFT1")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var topTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var bottomTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGreen
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Cell Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    override var isSelected: Bool {
        didSet {
            layer.cornerRadius = 12
            layer.borderWidth = isSelected ? 1.0 : 0.0
            layer.borderColor = UIColor.ypBlack?.cgColor
        }
    }

    private func setupCell() {
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(topTextLabel)
        containerView.addSubview(bottomTextLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            iconImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.heightAnchor.constraint(equalToConstant: 36),

            topTextLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            topTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            topTextLabel.widthAnchor.constraint(equalToConstant: 70),
            topTextLabel.heightAnchor.constraint(equalToConstant: 18),

            bottomTextLabel.topAnchor.constraint(equalTo: topTextLabel.bottomAnchor, constant: 0),
            bottomTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            bottomTextLabel.widthAnchor.constraint(equalToConstant: 70),
            bottomTextLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
