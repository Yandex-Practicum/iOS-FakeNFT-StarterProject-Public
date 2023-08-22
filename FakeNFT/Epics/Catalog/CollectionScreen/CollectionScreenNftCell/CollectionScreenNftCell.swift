//
//  CollectionScreenNftCell.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 04.08.2023.
//

import UIKit
import Kingfisher

final class CollectionScreenNftCell: UICollectionViewCell, ReuseIdentifying {
    var presenter: CollectionScreenNftCellPresenterProtocol?
    
    private let emptyBasketImage: UIImage? = {
        return UIImage.addToBasket?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack)
    }()
    private let notEmptyBasketImage: UIImage? = {
        return UIImage.removeFromBasket?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack)
    }()
    
    private let nftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        let image = emptyBasketImage
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(basketButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        let image = UIImage.unliked
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(likeButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        presenter = nil
        nftImage.image = nil
        basketButton.setImage(emptyBasketImage, for: .normal)
        likeButton.setImage(UIImage.unliked, for: .normal)
        removeRating()
        nameLabel.text = ""
        costLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNftImage(link: URL?) {
        nftImage.kf.setImage(with: link)
    }
    
    func setNotEmptyBasketImage() {
        basketButton.setImage(notEmptyBasketImage, for: .normal)
    }
    
    func setButtonLikeImage(image: UIImage?) {
        likeButton.setImage(image, for: .normal)
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
    
    func setNameLabel(name: String) {
        nameLabel.text = name
    }
    
    func setCostLabel(cost: Float) {
        costLabel.text = "\(cost) EHT"
    }
    
    private func setView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(nftImage)
        contentView.addSubview(basketButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(ratingStack)
        contentView.addSubview(nameLabel)
        contentView.addSubview(costLabel)
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: contentView.frame.height/1.593),
            
            basketButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            basketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basketButton.widthAnchor.constraint(equalToConstant: 40),
            basketButton.heightAnchor.constraint(equalToConstant: 40),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            ratingStack.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 8),
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStack.widthAnchor.constraint(equalToConstant: contentView.frame.width/1.59),
            ratingStack.heightAnchor.constraint(equalToConstant: contentView.frame.height/14.3),
            
            nameLabel.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: basketButton.leadingAnchor),
            
            costLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            costLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            costLabel.trailingAnchor.constraint(equalTo: basketButton.leadingAnchor)
        ])
    }
    
    private func removeRating() {
        ratingStack.arrangedSubviews.forEach { star in
            star.removeFromSuperview()
            ratingStack.removeArrangedSubview(star)
        }
    }
    
    private func addToBasket() {
        setNotEmptyBasketImage()
        presenter?.viewAddedNftToBasket()
    }
    
    private func removeFromBasket() {
        basketButton.setImage(emptyBasketImage, for: .normal)
        presenter?.viewRemovedNftFromBasket()
    }
    
    private func setLike() {
        setButtonLikeImage(image: .liked)
        presenter?.viewDidSetLike()
    }
    
    private func setUnlike() {
        setButtonLikeImage(image: .unliked)
        presenter?.viewDidSetUnlike()
    }
    
    @objc private func basketButtonTap() {
        switch basketButton.image(for: .normal) {
        case emptyBasketImage:
            addToBasket()
        case notEmptyBasketImage:
            removeFromBasket()
        default:
            break
        }
    }
    
    @objc private func likeButtonTap() {
        switch likeButton.image(for: .normal) {
        case UIImage.liked:
            setUnlike()
        case UIImage.unliked:
            setLike()
        default:
            break
        }
    }
}
