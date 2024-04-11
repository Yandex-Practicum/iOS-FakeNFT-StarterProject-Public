//
//  FavoritesNFTCell.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 11.04.2024.
//

import Foundation
import UIKit

final class FavoritesNFTCell: UICollectionViewCell {
    // MARK: - Public Properties
    static let cellID = "FavoritesNFTCell"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypBlack")
        label.font = UIFont.sfProBold17
        return label
    }()
    
    lazy var ethLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypBlack")
        label.font = UIFont.sfProRegular15
        return label
    }()
    
    lazy var nftImage: UIImageView = {
        let imVi = UIImageView()
        imVi.contentMode = .scaleAspectFit
        return imVi
    }()
    
    lazy var ratingImage: SpecialRatingView = {
        let imVi = SpecialRatingView()
        return imVi
    }()
    
    // MARK: - Private Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customizingScreenElements()
        customizingTheLayoutOfScreenElements()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Action
    @objc func tapLikeButton() {
        print("Кнопка likeButton работает")
    }
    
    // MARK: - Public Methods
    func changingNFT(image: String, name: String, rating: Int, price: String) {
        nftImage.image = UIImage(named: image)
        nameLabel.text = name
        ratingImage.ratingVisualization(rating: rating)
        ethLabel.text = price
    }
    
    // MARK: - Private Methods
    private func customizingScreenElements() {
        [nftImage, mainStackView].forEach {contentView.addSubview($0)}
        [stackView, ethLabel].forEach {mainStackView.addArrangedSubview($0)}
        [nameLabel, ratingImage.view].forEach {stackView.addArrangedSubview($0)}
    }
    
    private func customizingTheLayoutOfScreenElements() {
        [nftImage, mainStackView].forEach {$0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            nftImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: 80),
            nftImage.widthAnchor.constraint(equalToConstant: 80),
            
            mainStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: 66),
        ])
    }
}
