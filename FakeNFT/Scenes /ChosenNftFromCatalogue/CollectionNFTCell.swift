//
//  CollectionNFTCell.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 17.09.2024.
//

import Foundation
import UIKit

final class CollectionNFTCell: UICollectionViewCell {
    static let reuseIdentifier = "collectionNFTCell"
    private var trashIsTapped: Bool = false
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var starButtons: [UIButton] = []
    private let maxStars = 5
    private let starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var nameLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    var priceLabel: UILabel = {
        let price = UILabel()
        price.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        price.textColor = .black
        price.translatesAutoresizingMaskIntoConstraints = false
        return price
    }()
    
    let trashButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "deleteButtonEmpty"), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(trashButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [imageView, starsStackView, nameLabel, priceLabel, trashButton].forEach{contentView.addSubview($0)}
        
        for i in 0..<maxStars {
            let starButton = UIButton()
            starButton.tag = i + 1
            starButton.setImage(UIImage(named: "starNoSelect"), for: .normal)
            starButton.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starButtons.append(starButton)
            starsStackView.addArrangedSubview(starButton)
            starButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
            starButton.widthAnchor.constraint(equalToConstant: 12).isActive = true
        }
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 108),
            imageView.widthAnchor.constraint(equalToConstant: 108),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            starsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            starsStackView.heightAnchor.constraint(equalToConstant: 12),
            starsStackView.widthAnchor.constraint(equalToConstant: 68),
            starsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            nameLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 4),
            nameLabel.widthAnchor.constraint(equalToConstant: 68),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            priceLabel.heightAnchor.constraint(equalToConstant: 16),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.widthAnchor.constraint(equalToConstant: 68),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trashButton.heightAnchor.constraint(equalToConstant: 40),
            trashButton.widthAnchor.constraint(equalToConstant: 40),
            trashButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            trashButton.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 4)
        ])
    }
    
    @objc private func starTapped(_ sender: UIButton) {
        let rating = sender.tag
        for (index, button) in starButtons.enumerated() {
            if index < rating {
                button.setImage(UIImage(named: "starSelected"), for: .normal)
            } else {
                button.setImage(UIImage(named: "starNoSelect"), for: .normal)
            }
        }
    }
    
    @objc private func trashButtonTapped(_ sender: UIButton) {
        trashIsTapped.toggle()
        if self.trashIsTapped == false {
            trashButton.setImage(UIImage(named: "deleteButtonEmpty"), for: .normal)
        } else {
            trashButton.setImage(UIImage(named: "deleteButton"), for: .normal)
        }
        print("Trash button tapped")
    }
}
