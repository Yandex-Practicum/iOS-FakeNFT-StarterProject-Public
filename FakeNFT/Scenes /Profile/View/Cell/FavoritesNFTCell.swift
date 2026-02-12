//
//  FavoritesNFTCell.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 24.01.2026.
//

import UIKit

final class FavoritesNFTCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "FavoritesNFTCell"
    
    // MARK: - UI Elements
    
    private let imageNFTView: UIImageView = .baseNFTImage()
    private let likeButton: UIButton = .likeButton(color: .redUniversal)
    private let titleLabel: UILabel = .baseLabel(font: .systemFont(ofSize: 17, weight: .bold))
    private let starsImageView: UIImageView = .starsImageView()
    private let priceValueLabel: UILabel = .baseLabel(font: .systemFont(ofSize: 15, weight: .regular))
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView.stackVertical(spacing: 4, views: [titleLabel, starsImageView, priceValueLabel])
        stack.alignment = .leading
        stack.setCustomSpacing(8, after: starsImageView)
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .whiteApp
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func addSubviews() {
        [imageNFTView, likeButton, infoStack].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        [imageNFTView, likeButton, infoStack].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            imageNFTView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageNFTView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageNFTView.widthAnchor.constraint(equalToConstant: 80),
            imageNFTView.heightAnchor.constraint(equalToConstant: 80),
            
            likeButton.topAnchor.constraint(equalTo: imageNFTView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageNFTView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
            infoStack.leadingAnchor.constraint(equalTo: imageNFTView.trailingAnchor, constant: 20),
            infoStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Configure
    
    func configure(with model: NFTCartModel) {
        imageNFTView.image = UIImage(named: model.imageName)
        likeButton.setImage(UIImage(named: model.likeImageName), for: .normal)
        titleLabel.text = model.title
        starsImageView.image = UIImage(named: model.starsImageName)
        priceValueLabel.text = String(format: "%.2f ETH", model.price)
    }
}
