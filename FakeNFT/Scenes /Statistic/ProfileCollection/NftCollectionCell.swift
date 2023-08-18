//
//  NftCollectionCell.swift
//  FakeNFT
//
//  Created by macOS on 23.06.2023.
//

import UIKit

final class NftCollectionCell: UICollectionViewCell, ReuseIdentifying {
    
    var delegate: NftCollectionCellDelegate? = nil
    var nft: Nft? = nil
    
    private let starCount = 5
    private var isLiked = false
    
    private var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "likeDisabledIcon"), for: .normal)
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        return button
    }()
    
    private var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    private var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .YPBlack
        label.numberOfLines = 1
        return label
    }()
    
    private var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        label.textColor = .YPBlack
        label.numberOfLines = 1
        return label
    }()
    
    private var addToCartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cartIcon"), for: .normal)
        button.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(nft: Nft) {
        self.nft = nft
        
        if let image = nft.images.first,
           let url = URL(string: image) {
            nftImageView.loadImage(url: url, cornerRadius: 120)
        }
        
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for index in 0..<starCount {
            let starImageView = UIImageView()
            let imageName = nft.rating >= index ? "starIcon" : "starDisabledIcon"
            starImageView.image = UIImage(named: imageName)
            ratingStackView.addArrangedSubview(starImageView)
        }
        
        nftPriceLabel.text = "\(nft.price) ETH"
        nftNameLabel.text = nft.name
    }
    
    @objc private func addToCartTapped() {
        if let name = nft?.name {
            delegate?.onAddToCart(nftName: name)
        }
    }
    
    @objc private func likeTapped() {
        isLiked.toggle()
        let imageName = isLiked ? "likeIcon" : "likeDisabledIcon"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    private func addViews() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(nftNameLabel)
        contentView.addSubview(nftPriceLabel)
        contentView.addSubview(addToCartButton)
    }
    
    private func setUpConstraints() {
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        nftNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nftPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 12),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -12),
            likeButton.widthAnchor.constraint(equalToConstant: 21),
            likeButton.heightAnchor.constraint(equalToConstant: 18),
            
            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            
            nftNameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            nftNameLabel.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor),
            
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            nftPriceLabel.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor),
            
            addToCartButton.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addToCartButton.widthAnchor.constraint(equalToConstant: 40),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
}
