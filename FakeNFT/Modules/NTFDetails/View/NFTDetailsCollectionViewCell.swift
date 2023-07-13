//
//  NFTDetailsCollectionViewCell.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

final class NFTDetailsCollectionViewCell: UICollectionViewCell {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let stackViewRating: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
//        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let horizontalDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let verticalDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let favouriteImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let trashImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()

    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 12
        return image
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    static let reuseIdentifier = description()

    var action: ((Action) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGestureRecognizers() {
        let trashImagetapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(trashImageTapped))
        trashImageView.isUserInteractionEnabled = true
        trashImageView.addGestureRecognizer(trashImagetapGestureRecognizer)

        let favouriteImagetapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(favouriteImageTapped))
        favouriteImageView.isUserInteractionEnabled = true
        favouriteImageView.addGestureRecognizer(favouriteImagetapGestureRecognizer)
    }

    @objc private func trashImageTapped() {
        action?(.tapOnBasket)
    }

    @objc private func favouriteImageTapped() {
        action?(.tapFavourite)
    }

    private func setupSubviews() {
        contentView.layer.cornerRadius = 12

        contentView.addSubview(stackView)
        contentView.addSubview(favouriteImageView)

        NSLayoutConstraint.activate([

            favouriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            favouriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            image.heightAnchor.constraint(equalToConstant: 108),
            image.widthAnchor.constraint(equalToConstant: 108),

            trashImageView.heightAnchor.constraint(equalToConstant: 40),
            trashImageView.widthAnchor.constraint(equalToConstant: 40),

            favouriteImageView.heightAnchor.constraint(equalToConstant: 40),
            favouriteImageView.widthAnchor.constraint(equalToConstant: 40)

        ])

        stackView.addArrangedSubview(image)
        stackView.setCustomSpacing(8, after: image)
        stackView.addArrangedSubview(stackViewRating)
        stackViewRating.isLayoutMarginsRelativeArrangement = true
        stackViewRating.layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 40)
        stackView.addArrangedSubview(horizontalDetailsStackView)
        horizontalDetailsStackView.addArrangedSubview(verticalDetailsStackView)

        verticalDetailsStackView.addArrangedSubview(nameLabel)
        verticalDetailsStackView.addArrangedSubview(priceLabel)

        horizontalDetailsStackView.addArrangedSubview(trashImageView)

    }
}

extension NFTDetailsCollectionViewCell {
    struct Configuration {
        let name: String
        let rating: Int
        let price: String
        let imageUrl: String
        let isFavourite: Bool
        let addedToBasket: Bool
    }

    func configure(_ configuration: Configuration) {
        nameLabel.text = configuration.name
        priceLabel.text = configuration.price

        favouriteImageView.image = configuration.isFavourite
        ? .init(named: "selected_icon")
        : .init(named: "unselected_icon")

        trashImageView.image = configuration.addedToBasket
        ? .init(named: "filled_trash")
        : .init(named: "empty_trash")

        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .unspecified)
        let starImage = UIImage(systemName: "star.fill", withConfiguration: symbolConfiguration)
        let starImageFilled = UIImage(systemName: "star.fill", withConfiguration: symbolConfiguration)

        stackViewRating.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
            stackViewRating.removeArrangedSubview(view)
        }

        for index in 1...5 {
            let imageViewFilled = UIImageView(image: starImageFilled)
            imageViewFilled.contentMode = .scaleAspectFit
            imageViewFilled.tintColor = .yellowUniversal

            let imageViewEmpty = UIImageView(image: starImage)
            imageViewEmpty.contentMode = .scaleAspectFit
            imageViewEmpty.tintColor = .lightGrey
            if index <= configuration.rating {
                stackViewRating.addArrangedSubview(imageViewFilled)
            } else {
                stackViewRating.addArrangedSubview(imageViewEmpty)
            }
        }

        let url = URL(string: configuration.imageUrl.encodeUrl)
        image.kf.setImage(with: url)
    }
}

extension NFTDetailsCollectionViewCell {
    enum Action {
        case tapFavourite
        case tapOnBasket
    }
}
