//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/27/25.
//
import UIKit

final class NFTCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Elements
    private lazy var nftImage: UIImageView = {
        let imageView = UIImageView()
        // TODO: - Add stub image or animating
        imageView.image = UIImage(named: "stub_avatar")
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "no_active_like"), for: .normal)
        button.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var rateView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name Test"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "13.5 TST"
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cart"), for: .normal)
        button.addTarget(self, action: #selector(tapCartButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Public Properties
    static let reuseIdentifier = "NFTCollectionViewCell"
    // MARK: - Private Properties
    private var isLiked = false
    private var isAddToCart = false
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nftImage)
        contentView.addSubview(likeButton)
        contentView.addSubview(rateView)
        contentView.addSubview(nftNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(cartButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    @objc private func tapLikeButton() {
        isLiked = !isLiked
        likeButton.setImage(UIImage(named: isLiked ? "active_like" : "no_active_like"), for: .normal)
    }
    @objc private func tapCartButton() {
        isAddToCart = !isAddToCart
        cartButton.setImage(UIImage(named: isAddToCart ? "add_cart" : "cart"), for: .normal)
    }
    // MARK: - Public methods
    func configure(with nft: NFTCollectionModel) {
        if let nftUrl = URL(string: nft.images[1]) {
            nftImage.kf.setImage(with: nftUrl, placeholder: UIImage(named: "stub_avatar"))
        }
        setup(rating: nft.rating)
        nftNameLabel.text = nft.name
        priceLabel.text = String("\(nft.price) ETH")
        
    }
    // MARK: - Private methods
    private func setup(rating: Int) {
        var previousStar: UIImageView?
        for i in 0..<5 {
            let star = UIImageView()
            star.image = UIImage(named: i < rating ? "active_star" : "no_active_star")
            star.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(star)
            
            NSLayoutConstraint.activate([
                star.heightAnchor.constraint(equalToConstant: 12),
                star.widthAnchor.constraint(equalToConstant: 12),
                star.centerYAnchor.constraint(equalTo: rateView.centerYAnchor)
            ])
            
            if let previous = previousStar {
                star.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 2).isActive = true
            } else {
                star.leadingAnchor.constraint(equalTo: rateView.leadingAnchor).isActive = true
            }
            
            previousStar = star
        }
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImage.heightAnchor.constraint(equalTo: nftImage.widthAnchor),
            
            likeButton.topAnchor.constraint(equalTo: nftImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            
            rateView.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 8),
            rateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rateView.heightAnchor.constraint(equalToConstant: 12),
            rateView.widthAnchor.constraint(equalToConstant: 68),
            
            cartButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor),
            cartButton.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 24),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            
            nftNameLabel.topAnchor.constraint(equalTo: rateView.bottomAnchor, constant: 5),
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor)
        ])
    }
}
