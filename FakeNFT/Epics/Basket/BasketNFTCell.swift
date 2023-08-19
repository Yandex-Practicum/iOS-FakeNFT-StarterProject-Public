//
//  BasketNFTCell.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 04/08/2023.
//

import Kingfisher
import UIKit

protocol BasketNFTCellDelegate: AnyObject {
    func didTapRemoveButton(on nft: NftModel)
}

final class BasketNFTCell: UITableViewCell {
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    private let nftLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlackUniversal
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "Цена"
        label.textColor = .ypBlackUniversal
        return label
    }()
    
    private let priceValue: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlackUniversal
        return label
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.delete, for: .normal)
        button.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: BasketNFTCellDelegate?
    private var model: NftModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with model: NftModel) {
        self.model = model
        if
            let image = model.images.first,
            let url = URL(string: image)
        {
            nftImageView.kf.setImage(with: url)
        }
        nftLabel.text = model.name
        priceValue.text = "\(model.price) ETH"
        
        for star in 0..<model.rating {
            ratingStackView.arrangedSubviews[star].tintColor = .yellow
        }
        for star in model.rating..<5 {
            ratingStackView.arrangedSubviews[star].tintColor = .ypLightGrayDay
        }
    }
    
    
    @objc private func didTapRemoveButton() {
        guard let model else { return }
        delegate?.didTapRemoveButton(on: model)
    }
}

private extension BasketNFTCell {
    func setupView() {
        contentView.backgroundColor = .white
        
        [
            nftImageView,
            nftLabel,
            ratingStackView,
            priceLabel,
            priceValue,
            removeButton
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        contentView.addSubview(nftImageView)
        contentView.addSubview(nftLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceValue)
        contentView.addSubview(removeButton)
        
        for _ in 0..<5 {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.tintColor = .lightGray
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 12)
            ])
            ratingStackView.addArrangedSubview(starImageView)
        }
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            nftImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            nftImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            nftLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 8),
            
            ratingStackView.leadingAnchor.constraint(equalTo: nftLabel.leadingAnchor),
            ratingStackView.topAnchor.constraint(equalTo: nftLabel.bottomAnchor, constant: 4),
            
            priceLabel.leadingAnchor.constraint(equalTo: nftLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: priceValue.topAnchor, constant: -2),
            
            priceValue.leadingAnchor.constraint(equalTo: nftLabel.leadingAnchor),
            priceValue.bottomAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: -8),
            
            removeButton.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

extension BasketNFTCell: ReuseIdentifying {}

extension BasketNFTCell {
    enum Constants {
        static let imageSize: CGFloat = 108
    }
}
