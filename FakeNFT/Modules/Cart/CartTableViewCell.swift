//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 31.07.2023.
//

import UIKit

final class CartTableViewCell: UITableViewCell, ReuseIdentifying {
    var nft: NFTCartCellViewModel? {
        didSet {
            guard let nft = self.nft else { return }
            self.nftImageView.image = nft.image
            self.titleLabel.text = nft.name
            self.starsView.rating = StarsView.Rating(rawValue: nft.rating) ?? .zero
            self.priceLabel.text = "\(nft.price) ETH"
        }
    }

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .appLightGray
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let starsView: StarsView = {
        let starsView = StarsView()
        starsView.translatesAutoresizingMaskIntoConstraints = false
        return starsView
    }()

    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Цена"
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
            self.nftImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.nftImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.nftImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            self.nftImageView.widthAnchor.constraint(equalTo: self.nftImageView.heightAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.nftImageView.topAnchor, constant: 8),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.nftImageView.trailingAnchor, constant: 16),

            self.starsView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4),
            self.starsView.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.starsView.widthAnchor.constraint(equalToConstant: 68),

            self.priceTitleLabel.topAnchor.constraint(equalTo: self.starsView.bottomAnchor, constant: 13),
            self.priceTitleLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),

            self.priceLabel.topAnchor.constraint(equalTo: self.priceTitleLabel.bottomAnchor, constant: 2),
            self.priceLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor)
        ])
    }
}
