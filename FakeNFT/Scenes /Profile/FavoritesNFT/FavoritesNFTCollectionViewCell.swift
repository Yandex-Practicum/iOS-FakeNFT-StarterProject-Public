//
//  FavoritesNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 05.09.2023.
//

import UIKit

final class FavoritesNFTCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoritesNFTCollectionViewCellIdentifier"

    let avatarView = NftAvatarView()

    private let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let ratingView = RatingView()

    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, ratingView, priceValueLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .systemBackground
        layouts()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(name: String, price: Float, rating: Int, image: UIImage) {
        self.avatar.image = image
        self.nameLabel.text = name
        self.priceValueLabel.text = "\(price) ETH"
        self.ratingView.rating = rating
    }

    private func layouts() {
        [nameLabel, ratingView, priceValueLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            priceStackView.addArrangedSubview(view)
        }

        [avatar, priceStackView].forEach { view in
            self.addSubview(view)
        }

        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: topAnchor),
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatar.heightAnchor.constraint(equalToConstant: 80),
            avatar.widthAnchor.constraint(equalToConstant: 80),

            priceStackView.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            priceStackView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            priceStackView.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            priceStackView.trailingAnchor.constraint(equalTo: trailingAnchor)

        ])

    }
}
