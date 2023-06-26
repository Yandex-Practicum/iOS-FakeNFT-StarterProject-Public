//
//  NFTDetailsCollectionViewCell.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

class NFTDetailsCollectionViewCell: UICollectionViewCell {

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
        stackView.alignment = .fill
        stackView.distribution = .fill
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
        image.image = .init(named: "unselected_icon")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let trashImageView: UIImageView = {
        let image = UIImageView()
        image.image = .init(named: "empty_trash")
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

        if trashImageView.image == .init(named: "empty_trash") {
            action?(.selectBasket)
            DispatchQueue.main.async {
                self.trashImageView.image = .init(named: "filled_trash")

            }
        } else {
            action?(.unselectBasket)
            DispatchQueue.main.async {
                self.trashImageView.image = .init(named: "empty_trash")
            }
        }
    }

    @objc private func favouriteImageTapped() {

        if favouriteImageView.image == .init(named: "unselected_icon") {
            action?(.selectFavourite)
            DispatchQueue.main.async {
                self.favouriteImageView.image = .init(named: "selected_icon")
            }
        } else {
            action?(.unselectFavourite)
            DispatchQueue.main.async {
                self.favouriteImageView.image = .init(named: "unselected_icon")
            }
        }
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
        stackView.addArrangedSubview(stackViewRating)
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
        let price: Double
        let imageUrl: String

    }

    func configure(_ configuration: Configuration) {
        nameLabel.text = configuration.name
        priceLabel.text = "\(configuration.price) ETH"

        let starImage = UIImage(systemName: "star")
        let starImageFilled = UIImage(systemName: "star.fill")

        for index in 1...5 {
            let imageViewFilled = UIImageView(image: starImageFilled)
            imageViewFilled.tintColor = .yellow

            let imageViewEmpty = UIImageView(image: starImage)
            imageViewEmpty.tintColor = .lightGray
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
        case selectFavourite
        case unselectFavourite
        case selectBasket
        case unselectBasket
    }
}
