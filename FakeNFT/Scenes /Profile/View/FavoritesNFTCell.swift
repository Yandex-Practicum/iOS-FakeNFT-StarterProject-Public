//
//  FavoritesNFTCell.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 11.04.2024.
//

import Foundation
import UIKit
import Kingfisher

protocol FavoritesNFTCellDelegate: AnyObject {
    func didTapLikeButton(cell: FavoritesNFTCell)
}

final class FavoritesNFTCell: UICollectionViewCell {
    // MARK: - Public Properties
    static let cellID = "FavoritesNFTCell"
    weak var delegate: FavoritesNFTCellDelegate?
    
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
        imVi.backgroundColor = UIColor(named: "ypBlueUn")
        imVi.layer.cornerRadius = 12
        imVi.clipsToBounds = true
        return imVi
    }()
    
    lazy var ratingImage: SpecialRatingView = {
        let imVi = SpecialRatingView()
        return imVi
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = UIColor(named: "ypRedUn")
        button.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Private Properties
    private var id: String?
    
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
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 8
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
        delegate?.didTapLikeButton(cell: self)
    }
    
    // MARK: - Public Methods
    func changingNFT(nft: NFT) {
        if let nftImageURLString = nft.images.first,
           let nftImageURL = URL(string: nftImageURLString) {
            nftImage.kf.setImage(with: nftImageURL)
        } else {
            nftImage.image = UIImage(named: "avatar_icon")
        }
        
        nameLabel.text = nft.name
        ratingImage.ratingVisualization(rating: nft.rating)
        ethLabel.text = String(format: "%.2f", nft.price) + " ETH"
        id = nft.id
    }
    
    // MARK: - Private Methods
    private func customizingScreenElements() {
        [nftImage, likeButton, mainStackView].forEach {contentView.addSubview($0)}
        [stackView, ethLabel].forEach {mainStackView.addArrangedSubview($0)}
        [nameLabel, ratingImage.view].forEach {stackView.addArrangedSubview($0)}
    }
    
    private func customizingTheLayoutOfScreenElements() {
        [nftImage, likeButton, mainStackView].forEach {$0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            nftImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: 80),
            nftImage.widthAnchor.constraint(equalToConstant: 80),
            
            mainStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: 66),
            
            likeButton.topAnchor.constraint(equalTo: nftImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
}
