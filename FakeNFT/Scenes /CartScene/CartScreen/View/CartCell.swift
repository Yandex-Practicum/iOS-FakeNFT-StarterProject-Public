//
//  CartCell.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 24.06.2023.
//

import UIKit

/// Delegate
protocol CartCellDelegate {
    
    func showDeleteView(index: Int)
    
}

/// Cell-class for UITableView
final class CartCell: UITableViewCell {
    
    // MARK: - Constants
    private enum Constants {
        
        static let imageIndents: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 0)
        static let nameIndents: UIEdgeInsets = .init(top: 24, left: 20, bottom: 0, right: 0)
        static let starStackIndents: UIEdgeInsets = .init(top: 4, left: 20, bottom: 0, right: 0)
        static let priceTitleIndents: UIEdgeInsets = .init(top: 12, left: 20, bottom: 0, right: 0)
        static let priceIndents: UIEdgeInsets = .init(top: 2, left: 20, bottom: 0, right: 0)
        static let deleteButtonIndents: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 16)
        static let starStackHeight = CGFloat(16)
        static let imageHeightWidth = CGFloat(108)
        
    }
    
    // MARK: - Properties & Init
    var delegate: CartCellDelegate?
    
    var indexCell: Int?
    
    let nftImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.image = UIImage(systemName: "photo")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nftName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nftPriceTitle: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nftPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "star")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let starStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "deleteCart"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProperties()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions & Methods
    
    /// Appearance customisation
    private func setupView() {
        NSLayoutConstraint.activate([
            nftImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.imageIndents.left),
            nftImage.topAnchor.constraint(equalTo: topAnchor, constant: Constants.imageIndents.top),
            nftImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.imageIndents.bottom),
            nftImage.widthAnchor.constraint(equalToConstant: Constants.imageHeightWidth),
            nftImage.heightAnchor.constraint(equalToConstant: Constants.imageHeightWidth),
            
            nftName.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: Constants.nameIndents.left),
            nftName.topAnchor.constraint(equalTo: topAnchor, constant: Constants.nameIndents.top),
            
            starImage.widthAnchor.constraint(equalToConstant: Constants.starStackHeight),
            starImage.heightAnchor.constraint(equalToConstant: Constants.starStackHeight),
            starStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: Constants.starStackIndents.left),
            starStack.topAnchor.constraint(equalTo: nftName.bottomAnchor, constant: Constants.starStackIndents.top),
            
            nftPriceTitle.topAnchor.constraint(equalTo: starStack.bottomAnchor, constant: Constants.priceTitleIndents.top),
            nftPriceTitle.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: Constants.priceTitleIndents.left),
            
            nftPrice.topAnchor.constraint(equalTo: nftPriceTitle.bottomAnchor, constant: Constants.priceIndents.top),
            nftPrice.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: Constants.priceIndents.left),
            
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.deleteButtonIndents.right),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    /// Setting properties
    private func setupProperties() {
        addSubview(nftImage)
        addSubview(nftName)
        addSubview(starStack)
        addSubview(nftPriceTitle)
        addSubview(nftPrice)
        contentView.addSubview(deleteButton)
        starStack.addArrangedSubview(starImage)
    }
    
    /// Setting up the rating
    func setupRating(rating: Int) {
        for arrangedSubview in starStack.arrangedSubviews {
            starStack.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        
        for _ in 0..<rating {
            let starImageView = UIImageView(image: UIImage(named: "star"))
            starImageView.tintColor = .systemYellow
            starStack.addArrangedSubview(starImageView)
        }
        
        let emptyStarsCount = 5 - rating
        for _ in 0..<emptyStarsCount {
            let emptyStarImageView = UIImageView(image: UIImage(named: "grayStar"))
            emptyStarImageView.tintColor = .gray
            starStack.addArrangedSubview(emptyStarImageView)
        }
    }
    
    @objc
    func deleteButtonTapped() {
        delegate?.showDeleteView(index: indexCell ?? 0)
    }
    
}
