import UIKit
import Kingfisher

private enum Consts {
    static let largeSpacing: CGFloat = 8
    static let smallSpacing: CGFloat = 4
    static let ratingHeight: CGFloat = 12
    static let nameHeight: CGFloat = 22
    static let priceHeight: CGFloat = 12
}

final class StatisticsUserNFTCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    private let usersCollectionItemImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let usersCollectionItemRating: UIImageView = {
        let rating = UIImageView()
        return rating
    }()

    private let usersCollectionItemName: UILabel = {
        let name = UILabel()
        name.font = .bodyBold
        return name
    }()

    private let usersCollectionItemPrice: UILabel = {
        let price = UILabel()
        price.font = .systemFont(ofSize: 10, weight: .medium)
        return price
    }()

    private let usersCollectionItemCart: UIImageView = {
        let cart = UIImageView()
        cart.image = UIImage(named: "cart")
        cart.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cart.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return cart
    }()

    private let usersCollectionItemFavoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(usersCollectionItemImage)
        usersCollectionItemImage.translatesAutoresizingMaskIntoConstraints = false

        usersCollectionItemImage.addSubview(usersCollectionItemFavoriteButton)
        usersCollectionItemFavoriteButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(usersCollectionItemName)
        usersCollectionItemName.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(usersCollectionItemRating)
        usersCollectionItemRating.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(usersCollectionItemPrice)
        usersCollectionItemPrice.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(usersCollectionItemCart)
        usersCollectionItemCart.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            usersCollectionItemImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            usersCollectionItemImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            usersCollectionItemImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            usersCollectionItemImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            usersCollectionItemFavoriteButton.topAnchor.constraint(equalTo: usersCollectionItemImage.topAnchor, constant: 10),
            usersCollectionItemFavoriteButton.trailingAnchor.constraint(equalTo: usersCollectionItemImage.trailingAnchor, constant: -10),

            usersCollectionItemRating.topAnchor.constraint(equalTo: usersCollectionItemImage.bottomAnchor, constant: 8),
            usersCollectionItemRating.heightAnchor.constraint(equalToConstant: 12),
            usersCollectionItemRating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            usersCollectionItemName.topAnchor.constraint(equalTo: usersCollectionItemRating.bottomAnchor, constant: 4),
            usersCollectionItemName.heightAnchor.constraint(equalToConstant: 22),
            usersCollectionItemName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            usersCollectionItemName.trailingAnchor.constraint(lessThanOrEqualTo: usersCollectionItemCart.leadingAnchor, constant: -8),

            usersCollectionItemPrice.topAnchor.constraint(equalTo: usersCollectionItemName.bottomAnchor, constant: 4),
            usersCollectionItemPrice.heightAnchor.constraint(equalToConstant: 12),
            usersCollectionItemPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            usersCollectionItemCart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            usersCollectionItemCart.topAnchor.constraint(equalTo: usersCollectionItemImage.bottomAnchor, constant: 24)
        ]

        constraints.forEach {
            $0.priority = .defaultHigh
        }

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: StatisticsUserNFTCollectionCellModel) {
        usersCollectionItemImage.kf.setImage(with: model.icon)
        usersCollectionItemFavoriteButton.tintColor = model.isLiked ? .red : .white
        setRating(rating: model.rating)
        usersCollectionItemName.text = model.name
        usersCollectionItemPrice.text = model.price
    }

    private func setRating(rating: StatisticsUserNFTCollectionCellModel.StarRating) {
        switch rating {
        case .zero:
            usersCollectionItemRating.image = UIImage(named: "propertyZero")
        case .one:
            usersCollectionItemRating.image = UIImage(named: "propertyOne")
        case .two:
            usersCollectionItemRating.image = UIImage(named: "propertyTwo")
        case .three:
            usersCollectionItemRating.image = UIImage(named: "propertyThree")
        case .four:
            usersCollectionItemRating.image = UIImage(named: "propertyFour")
        case .five:
            usersCollectionItemRating.image = UIImage(named: "propertyFive")
        }
    }
}

extension StatisticsUserNFTCollectionViewCell {
    static func heightForWidth(_ width: CGFloat) -> CGFloat {
        return width + Consts.largeSpacing + 2 * Consts.smallSpacing + Consts.ratingHeight + Consts.nameHeight + Consts.priceHeight
    }
}
