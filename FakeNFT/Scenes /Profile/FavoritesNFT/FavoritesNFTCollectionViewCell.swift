//
//  FavoritesNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 05.09.2023.
//

import UIKit
import Kingfisher

final class FavoritesNFTCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    static let identifier = "FavoritesNFTCollectionViewCellIdentifier"

    let avatarView = NftAvatarView()

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

    var likeButtonAction: (() -> Void)?

    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .systemBackground
        layouts()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(with nft: Nft) {
        avatarView.viewModel = NftAvatarViewModel(
            imageURL: nft.images.first,
            isLiked: true
        ) { [weak self] in
            self?.likeButtonAction?()
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "ru_Ru")
        if let formattedPrice = numberFormatter.string(from: NSNumber(value: nft.price)) {
            self.priceValueLabel.text = "\(formattedPrice) ETH"
        }
        self.nameLabel.text = nft.name
        self.ratingView.rating = nft.rating
        avatarView.setAI()
    }

    private func layouts() {
        [nameLabel, ratingView, priceValueLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            priceStackView.addArrangedSubview(view)
        }

        [avatarView, priceStackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 80),
            avatarView.widthAnchor.constraint(equalToConstant: 80),

            priceStackView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            priceStackView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            priceStackView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            priceStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
