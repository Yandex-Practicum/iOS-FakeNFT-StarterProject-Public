//
//  NFTCollectionInfoViewCell.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 07.08.2023.
//

import UIKit

final class NFTCollectionInfoViewCell: UICollectionViewCell {
    enum EventType {
        case favouriteClicked
        case binClicked
    }

    struct Configuration {
        let name: String
        let rating: Int
        let price: String
        let imageUrl: String
        let isFavourite: Bool
        let addedToBasket: Bool
    }

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()

    private lazy var ratingStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .leading
        view.spacing = 2
        return view
    }()

    private lazy var horizontalDetailsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()

    private lazy var verticalDetailsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()

    private lazy var favouriteImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var binImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .boldSystemFont(ofSize: 17)
        view.numberOfLines = 0
        return view
    }()

    private lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .systemFont(ofSize: 10)
        view.numberOfLines = 0
        return view
    }()

    var eventHandler: (EventHandler<EventType>)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError(
            "NFTCollectionInfoViewCell -> init(coder:) has not been implemented"
        )
    }

    private func setupGestureRecognizers() {
        let binGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(binClicked)
        )
        binImageView.addGestureRecognizer(binGesture)

        let favouriteGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(favouriteClicked))
        favouriteImageView.addGestureRecognizer(favouriteGesture)
    }

    @objc private func binClicked() {
        eventHandler?(.binClicked)
    }

    @objc private func favouriteClicked() {
        eventHandler?(.favouriteClicked)
    }

    private func setupSubviews() {
        contentView.layer.cornerRadius = 12

        contentView.addSubview(stackView)
        contentView.addSubview(favouriteImageView)

        let constraints = [
            favouriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            favouriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            image.heightAnchor.constraint(equalToConstant: 108),
            image.widthAnchor.constraint(equalToConstant: 108),

            binImageView.heightAnchor.constraint(equalToConstant: 40),
            binImageView.widthAnchor.constraint(equalToConstant: 40),

            favouriteImageView.heightAnchor.constraint(equalToConstant: 40),
            favouriteImageView.widthAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(constraints)

        stackView.addArrangedSubview(image)
        stackView.setCustomSpacing(8, after: image)
        stackView.addArrangedSubview(ratingStackView)
        ratingStackView.isLayoutMarginsRelativeArrangement = true
        ratingStackView.layoutMargins = .init(
            top: 0,
            left: 0,
            bottom: 0,
            right: 40
        )
        stackView.addArrangedSubview(horizontalDetailsStackView)
        horizontalDetailsStackView.addArrangedSubview(verticalDetailsStackView)

        verticalDetailsStackView.addArrangedSubview(nameLabel)
        verticalDetailsStackView.addArrangedSubview(priceLabel)

        horizontalDetailsStackView.addArrangedSubview(binImageView)
    }
    
    func configure(with configuration: Configuration) {
        nameLabel.text = configuration.name
        priceLabel.text = configuration.price

        favouriteImageView.image = configuration.isFavourite
        ? .init(named: "selected_icon")
        : .init(named: "unselected_icon")

        binImageView.image = configuration.addedToBasket
        ? .init(named: "bin_filled")
        : .init(named: "bin_empty")

        let symbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 12,
            weight: .regular,
            scale: .unspecified
        )
        let starImage = UIImage(
            systemName: "star.fill",
            withConfiguration: symbolConfiguration
        )
        let starImageFilled = UIImage(
            systemName: "star.fill",
            withConfiguration: symbolConfiguration
        )

        ratingStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
            ratingStackView.removeArrangedSubview(view)
        }

        for index in 1...5 {
            let filledView = UIImageView(image: starImageFilled)
            filledView.contentMode = .scaleAspectFit
            filledView.tintColor = .yellowUniversal

            let emptyView = UIImageView(image: starImage)
            emptyView.contentMode = .scaleAspectFit
            emptyView.tintColor = .lightGrey
            
            if index <= configuration.rating {
                ratingStackView.addArrangedSubview(filledView)
            } else {
                ratingStackView.addArrangedSubview(emptyView)
            }
        }

        image.kf.setImage(
            with: URL(string: configuration.imageUrl.encodeUrl)
        )
    }
}
