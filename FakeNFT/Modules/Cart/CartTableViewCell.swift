import UIKit

final class CartTableViewCell: UITableViewCell, ReuseIdentifying {
    private enum Constants {
        static let nftImageViewCornerRadius: CGFloat = 12
        static let nftImageViewEdgeInset: CGFloat = 16

        static let titleLabelTopInset: CGFloat = 8
        static let titleLabelSideInset: CGFloat = 16

        static let starsViewTopInset: CGFloat = 4
        static let starsViewWidth: CGFloat = 68

        static let priceTitleLabelTopInset: CGFloat = 13
        static let priceLabelTopInset: CGFloat = 2

        static var boldFont: UIFont { .getFont(style: .bold, size: 17) }
        static var regularFont: UIFont { .getFont(style: .regular, size: 13) }
    }

    var nft: NFTCartCellViewModel? {
        didSet {
            guard let nft = self.nft else { return }
            self.nftImageView.image = nft.image
            self.titleLabel.text = nft.name
            self.starsView.rating = StarsView.Rating(rawValue: nft.rating) ?? .zero
            self.priceLabel.text = "\(nft.price.nftCurrencyFormatted) ETH"
        }
    }

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .appLightGray
        imageView.layer.cornerRadius = Constants.nftImageViewCornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.boldFont
        return label
    }()

    private let starsView = StarsView()

    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CART_CELL_PRICE_TITLE_LABEL".localized
        label.font = Constants.regularFont
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.boldFont
        return label
    }()

    private let cartAccessoryView: UIImageView = {
        let image = UIImage.Cart.active.withTintColor(.appBlack)
        let imageView = UIImageView(image: image)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nftImageView.image = nil
        self.titleLabel.text = ""
        self.starsView.rating = .zero
        self.priceLabel.text = ""
    }
}

private extension CartTableViewCell {
    func configure() {
        self.backgroundColor = .appWhite
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.contentView.addSubview(self.nftImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.starsView)
        self.contentView.addSubview(self.priceTitleLabel)
        self.contentView.addSubview(self.priceLabel)

        self.accessoryView = self.cartAccessoryView
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.nftImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                   constant: Constants.nftImageViewEdgeInset),
            self.nftImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                       constant: Constants.nftImageViewEdgeInset),
            self.nftImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                      constant: -Constants.nftImageViewEdgeInset),
            self.nftImageView.widthAnchor.constraint(equalTo: self.nftImageView.heightAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.nftImageView.topAnchor,
                                                 constant: Constants.titleLabelTopInset),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.nftImageView.trailingAnchor,
                                                     constant: Constants.titleLabelSideInset),

            self.starsView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,
                                                constant: Constants.starsViewTopInset),
            self.starsView.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.starsView.widthAnchor.constraint(equalToConstant: Constants.starsViewWidth),

            self.priceTitleLabel.topAnchor.constraint(equalTo: self.starsView.bottomAnchor,
                                                      constant: Constants.priceTitleLabelTopInset),
            self.priceTitleLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),

            self.priceLabel.topAnchor.constraint(equalTo: self.priceTitleLabel.bottomAnchor,
                                                 constant: Constants.priceLabelTopInset),
            self.priceLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor)
        ])
    }
}
