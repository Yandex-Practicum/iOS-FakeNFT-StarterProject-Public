//
//  CollectionScreenCollectionCell.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 04.08.2023.
//

import UIKit
import Kingfisher

final class CollectionScreenCollectionCell: UICollectionViewCell {
    static let cellReuseIdentifier = "CollectionScreenCollectionCell"
    
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
    private let ratingStack: UIStackView = {
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
        label.font = UIFont.caption3
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
        removeRating()
        nameLabel.text = ""
        costLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNftImage(link: String) {
        let url = URL(string: link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
        nftImage.kf.setImage(with: url)
    }
    
    private func addToBasket() {
        basketImage.image = .removeFromBasket
    }
    
    private func removeFromBasket() {
        basketImage.image = .addToBasket
    }
    
    private func setLike() {
        likeImage.image = .liked
    }
    
    private func setUnlike() {
        likeImage.image = .unliked
    }
    
    func setRating(rate: Int) {
        for index in 1...5 {
            if index <= rate {
                let yellowStar = UIImageView(image: .yellowStar)
                yellowStar.contentMode = .scaleAspectFit
                ratingStack.addArrangedSubview(yellowStar)
            } else {
                let grayStar = UIImageView(image: .grayStar)
                grayStar.contentMode = .scaleAspectFit
                ratingStack.addArrangedSubview(grayStar)
            }
        }
    }
    
    private func removeRating() {
        ratingStack.arrangedSubviews.forEach { star in
            star.removeFromSuperview()
            ratingStack.removeArrangedSubview(star)
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
        contentView.addSubview(ratingStack)
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
            
            ratingStack.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 8),
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStack.widthAnchor.constraint(equalToConstant: 68),
            ratingStack.heightAnchor.constraint(equalToConstant: 12),

            nameLabel.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: basketImage.leadingAnchor),
            
            costLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            costLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            costLabel.trailingAnchor.constraint(equalTo: basketImage.leadingAnchor)
        ])
    }
}
