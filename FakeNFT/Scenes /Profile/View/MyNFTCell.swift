//
//  MyNFTCell.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 04.04.2024.
//

import Foundation
import UIKit

final class MyNFTCell: UITableViewCell {
    
    // MARK: - Public Properties
    static let cellID = "MyNFTCell"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypBlack")
        label.text = "Lilo"
        label.font = UIFont.sfProBold17
        return label
    }()
    
    lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypBlack")
        label.text = "от"
        label.font = UIFont.sfProRegular15
        return label
    }()
    
    lazy var holderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypBlack")
        label.text = "John Doe"
        label.font = UIFont.sfProRegular13
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypBlack")
        label.text = "Цена"
        label.font = UIFont.sfProRegular13
        return label
    }()
    
    lazy var ethLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypBlack")
        label.text = "1,78 ЕТН"
        label.font = UIFont.sfProBold17
        return label
    }()
    
    lazy var nftImage: UIImageView = {
        let imVi = UIImageView()
        imVi.image = UIImage(named: "liloImage")
        imVi.contentMode = .scaleAspectFit
        return imVi
    }()
    
    lazy var ratingImage: UIImageView = {
        let imVi = UIImageView()
        imVi.image = UIImage(named: "ratingImage")
        imVi.contentMode = .scaleAspectFit
        return imVi
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Private Properties
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 35
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var fromStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()
    
    
    
    // MARK: - Initializers
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
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
    func changingNFT(image: String, name: String) {
        nftImage.image = UIImage(named: image)
        nameLabel.text = name
        
    }
    
    // MARK: - Private Methods
    private func customizingScreenElements() {
        [nftImage, infoStackView, likeButton].forEach {contentView.addSubview($0)}
        [nameStackView, priceStackView].forEach {infoStackView.addArrangedSubview($0)}
        [priceLabel, ethLabel].forEach {priceStackView.addArrangedSubview($0)}
        [nameLabel, ratingImage, fromStackView].forEach {nameStackView.addArrangedSubview($0)}
        [fromLabel, holderLabel].forEach {fromStackView.addArrangedSubview($0)}
    }
    
    private func customizingTheLayoutOfScreenElements() {
        [nftImage, infoStackView, likeButton].forEach {$0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            nftImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            
            infoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23),
            infoStackView.heightAnchor.constraint(equalToConstant: 62),
            
            likeButton.topAnchor.constraint(equalTo: nftImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
}
//Test

