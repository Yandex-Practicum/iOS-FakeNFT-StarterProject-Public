//
//  NFTCollectionCell.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 01.04.2025.
//


import UIKit
import Kingfisher

final class NFTCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "NFTCollectionCell"
    var likeButtonTapped: (() -> Void)?
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(named: "YBlackColor")
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        for _ in 0..<5 {
            let star = UIImageView(image: UIImage(named: "white_star"))
            star.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(star)
        }
        return stackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "YBlackColor")
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "red_heart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(likeButton)
        infoStackView.addArrangedSubview(nftNameLabel)
        infoStackView.addArrangedSubview(ratingStackView)
        infoStackView.addArrangedSubview(priceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 29.63),
            likeButton.heightAnchor.constraint(equalToConstant: 29.63),
            
            infoStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -7),
        ])
    }
    
    func configure(with nft: MyNFT, formattedPrice: String) {
        if let imageURL = nft.images.first, let url = URL(string: imageURL) {
            nftImageView.kf.setImage(with: url)
        }
        
        let extractedName = nft.images.first.flatMap { imageURL in
            extractName(from: [imageURL])
        }
        nftNameLabel.text = extractedName
        priceLabel.text = formattedPrice
        updateRating(for: nft.rating)
    }
    
    private func extractName(from images: [String]) -> String? {
        guard let firstImage = images.first else { return nil }
        let components = firstImage.split(separator: "/")
        guard components.count > 2 else { return nil }
        return String(components[components.count - 2])
    }
    
    private func updateRating(for rating: Int) {
        for (index, view) in ratingStackView.arrangedSubviews.enumerated() {
            guard let starImageView = view as? UIImageView else { continue }
            starImageView.image = UIImage(named: index < rating ? "yellow_star" : "white_star")
        }
    }
    
    @objc private func didTapLikeButton() {
        likeButtonTapped?()
    }
}
