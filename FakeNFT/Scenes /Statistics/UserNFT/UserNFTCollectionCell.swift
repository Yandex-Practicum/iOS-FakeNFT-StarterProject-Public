//
//  UserNFTCollectionCell.swift
//  FakeNFT
//
//  Created by Сергей on 26.04.2024.
//

import UIKit
import Kingfisher

protocol UserNFTCellDelegate: AnyObject {
    func addFavouriteButtonClicked(_ cell: UserNFTCollectionCell, nft: NFTModel)
    func addToCartButtonClicked(_ cell: UserNFTCollectionCell, nft: NFTModel)
}

final class UserNFTCollectionCell: UICollectionViewCell {

    static let identifier = "UserNFTCollectionCell"

    weak var delegate: UserNFTCellDelegate?

    private var nft: NFTModel?
    private var cart: OrderModel?

    private let userNFTService = UserNFTService.shared

    private let ratingStarsView: RatingStarsView = {
        let view = RatingStarsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .medium)
        return label
    }()

    private lazy var addFavouriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var addToCart: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    private func setViews() {
        [nftImage, nameLabel, priceLabel, ratingStarsView, addToCart].forEach {
            contentView.addSubview($0)
        }

        nftImage.addSubview(addFavouriteButton)
        setConstraints()

        addFavouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: (contentView.bounds.height / 5) * 3 ),
            addFavouriteButton.topAnchor.constraint(equalTo: nftImage.topAnchor),
            addFavouriteButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor),
            addFavouriteButton.heightAnchor.constraint(equalToConstant: 40),
            addFavouriteButton.widthAnchor.constraint(equalToConstant: 40),
            ratingStarsView.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 8),
            ratingStarsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStarsView.heightAnchor.constraint(equalToConstant: 12),
            nameLabel.topAnchor.constraint(equalTo: ratingStarsView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: addToCart.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addToCart.heightAnchor.constraint(equalToConstant: 40),
            addToCart.widthAnchor.constraint(equalToConstant: 40),
            addToCart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addToCart.topAnchor.constraint(equalTo: ratingStarsView.bottomAnchor, constant: 4)
        ])
    }

    func setIsLiked(isLiked: Bool) {
        let like = isLiked ? UIImage(named: "favoutiteImage")?.withTintColor(UIColor.yaFavourite) : UIImage(named: "favoutiteImage")
        addFavouriteButton.setImage(like, for: .normal)
    }

    func setIsAdded(isAdded: Bool) {
        let add = isAdded ? UIImage(named: "deleteFromCart") : UIImage(named: "addToCart")
        addToCart.setImage(add, for: .normal)
    }

    @objc private func favouriteButtonTapped() {
        guard let nft = self.nft else { return }
        userNFTService.nft = nft
        delegate?.addFavouriteButtonClicked(self, nft: nft)

    }

    @objc private func addToCartButtonTapped() {
        guard let nft = self.nft else { return }
        userNFTService.nft = nft
        delegate?.addToCartButtonClicked(self, nft: nft)
    }

    func set(nft: NFTModel, cart: OrderModel, profile: ProfileModel) {
        self.nft = nft
        nftImage.kf.indicatorType = .activity
        let url = URL(string: nft.images.first ?? "")
        nftImage.kf.setImage(with: url) { [weak self] _ in
            guard let self = self else { return }
            self.nftImage.kf.indicatorType = .none
        }
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        ratingStarsView.rating = nft.rating

        if profile.likes.contains(nft.id) {
            addFavouriteButton.setImage(UIImage(named: "favoutiteImage")?.withTintColor(UIColor.yaFavourite), for: .normal)
        } else {
            addFavouriteButton.setImage(UIImage(named: "favoutiteImage"), for: .normal)
        }

        if cart.nfts.contains(nft.id) {
            addToCart.setImage(UIImage(named: "deleteFromCart"), for: .normal)
        } else {
            addToCart.setImage(UIImage(named: "addToCart"), for: .normal)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
