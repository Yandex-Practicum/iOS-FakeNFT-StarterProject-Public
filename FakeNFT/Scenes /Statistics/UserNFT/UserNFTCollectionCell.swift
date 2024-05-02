//
//  UserNFTCollectionCell.swift
//  FakeNFT
//
//  Created by Сергей on 26.04.2024.
//

import UIKit


final class UserNFTCollectionCell: UICollectionViewCell {
    
    static let identifier = "UserNFTCollectionCell"
    
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
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    
    private let ratingStarsView: RatingStarsView = {
       let view = RatingStarsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
//        addFavouriteButton.
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
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addToCart.heightAnchor.constraint(equalToConstant: 40),
            addToCart.widthAnchor.constraint(equalToConstant: 40),
            addToCart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addToCart.topAnchor.constraint(equalTo: ratingStarsView.bottomAnchor, constant: 4)
            
            
        ])
       
    }
    
    @objc private func favouriteButtonTapped() {
        print("favouriteButtonTapped")
    }
    
    @objc private func addToCartButtonTapped() {
        print("addToCartButtonTapped")
    }
    
    func set(image: UIImage, name: String, price: Float, rating: Int) {
        nftImage.image = image
        addFavouriteButton.setImage(UIImage(named: "favoutiteImage"), for: .normal)
        addToCart.setImage(UIImage(named: "addToCart"), for: .normal)
        nameLabel.text = name
        priceLabel.text = "\(price) ETH"
        ratingStarsView.rating = rating
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
