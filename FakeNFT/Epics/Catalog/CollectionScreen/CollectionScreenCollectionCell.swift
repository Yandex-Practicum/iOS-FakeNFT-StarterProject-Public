//
//  CollectionScreenCollectionCell.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 04.08.2023.
//

import UIKit
import Kingfisher

final class CollectionScreenCollectionCell: UICollectionViewCell {
    static let cellReuseIdentifier = "collectionScreenCell"
    
    private let nftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let basketImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .addToBasket?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let likeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .unliked
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let rating: UIStackView = {
        let starImage = UIImageView()
        starImage.image = .grayStar
        starImage.contentMode = .scaleAspectFit
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fillEqually
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10) //вынести
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImage.image = nil
        basketImage.image = .addToBasket?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack)
        likeImage.image = .unliked
        rating.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
            rating.removeArrangedSubview(view)
        }
        nameLabel.text = ""
        costLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNftImage(link: String) {
        nftImage.kf.setImage(with: URL(string: link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!))
    }
    
    func addToBasket() {
        basketImage.image = .removeFromBasket
    }
    
    func removeFromBasket() {
        basketImage.image = .addToBasket
    }
    
    func setLike() {
        likeImage.image = .liked
    }
    
    func setUnlike() {
        likeImage.image = .unliked
    }
    
    func setRating(rate: Int) {
        rating.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
            rating.removeArrangedSubview(view)
        }
        
        for index in 1...5 {
            let filledView = UIImageView(image: .yellowStar)
            filledView.contentMode = .scaleAspectFit
            
            let emptyView = UIImageView(image: .grayStar)
            emptyView.contentMode = .scaleAspectFit
            
            if index <= rate {
                rating.addArrangedSubview(filledView)
            } else {
                rating.addArrangedSubview(emptyView)
            }
        }
    }
    
    func setNameLabel(name: String) {
        nameLabel.text = name
    }
    
    func setCostLabel(cost: Float) {
        costLabel.text = "\(cost) EHT"
    }
    
    private func setView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(nftImage)
        contentView.addSubview(basketImage)
        contentView.addSubview(likeImage)
        contentView.addSubview(rating)
        contentView.addSubview(nameLabel)
        contentView.addSubview(costLabel)
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            
            basketImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            basketImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basketImage.widthAnchor.constraint(equalToConstant: 40),
            basketImage.heightAnchor.constraint(equalToConstant: 40),
            
            likeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeImage.widthAnchor.constraint(equalToConstant: 40),
            likeImage.heightAnchor.constraint(equalToConstant: 40),
            
            rating.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 8),
            rating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rating.heightAnchor.constraint(equalToConstant: 12),
            rating.widthAnchor.constraint(equalToConstant: 68),
            
            nameLabel.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: basketImage.leadingAnchor),
            
            costLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            costLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            costLabel.trailingAnchor.constraint(equalTo: basketImage.leadingAnchor)
        ])
    }
}
