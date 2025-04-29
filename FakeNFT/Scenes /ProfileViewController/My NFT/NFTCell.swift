//
//  NFTCell.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 29.03.2025.
//


import UIKit
import Kingfisher

final class NFTCell: UITableViewCell {

    static let reuseIdentifier = "NFTCell"
    private var priceLabel: UILabel?
    var likeButtonTapped: (() -> Void)?
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "white_heart"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()

    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(named: "YBlackColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.image = UIImage(named: "white_star")
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            stackView.addArrangedSubview(starImageView)
        }
        return stackView
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "YBlackColor")
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let priceTitleLabel = UILabel()
        priceTitleLabel.text = NSLocalizedString("Price", comment: "")
        priceTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        priceTitleLabel.textColor = UIColor(named: "YBlackColor")
        stackView.addArrangedSubview(priceTitleLabel)

        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        priceLabel.textColor = UIColor(named: "YBlackColor")
        priceLabel.text = "0.0"
        self.priceLabel = priceLabel
        stackView.addArrangedSubview(priceLabel)

        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(nftNameLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(priceStack)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),

            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),

            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 39),
            nftNameLabel.heightAnchor.constraint(equalToConstant: 22),

            ratingStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            ratingStackView.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),

            authorLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            authorLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4),
            authorLabel.heightAnchor.constraint(equalToConstant: 40),

            priceStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            priceStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with nft: MyNFT, isLiked: Bool, formattedPrice: String) {
        let extractedName = nft.images.first.flatMap { imageURL in
            extractName(from: [imageURL])
        }
        nftNameLabel.text = extractedName

        let authorName = nft.name
            if authorName.count > 10 {
                let formattedAuthorName = authorName.replacingOccurrences(of: " ", with: "\n")
                authorLabel.text = "\(NSLocalizedString("by", comment: "")) \(formattedAuthorName)"
            } else {
                authorLabel.text = "\(NSLocalizedString("by", comment: "")) \(authorName)"
            }
        if let priceLabel = priceLabel {
                   priceLabel.text = formattedPrice
               }
        
        if let imageURL = nft.images.first, let url = URL(string: imageURL) {
            nftImageView.kf.setImage(with: url)
        }
        updateRating(for: nft.rating)
        let likeImage = isLiked ? "red_heart" : "white_heart"
        likeButton.setImage(UIImage(named: likeImage), for: .normal)
       
    }

    private func extractName(from images: [String]) -> String? {
        guard let firstImage = images.first else { return nil }
        let components = firstImage.split(separator: "/")
        guard components.count > 2 else { return nil }
        return String(components[components.count - 2])
    }

    private func updateRating(for rating: Int) {
        guard rating >= 0 && rating <= 5 else { return }

        for (index, view) in ratingStackView.arrangedSubviews.enumerated() {
            guard let starImageView = view as? UIImageView else { continue }

            if index < rating {
                starImageView.image = UIImage(named: "yellow_star")
            } else {
                starImageView.image = UIImage(named: "white_star")
            }
        }
    }
    
    @objc private func didTapLikeButton() {
           likeButtonTapped?()
       }
}
