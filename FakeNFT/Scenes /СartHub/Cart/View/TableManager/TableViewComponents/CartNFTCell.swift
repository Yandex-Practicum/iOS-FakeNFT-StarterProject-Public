//
//  CartNFTCell.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit
import Kingfisher

protocol CartNFTCellDelegate: AnyObject {
    func deleteNFTButtonDidTapped(with id: String, imageURL: String, returnHandler: ((Bool) -> Void)?)
}

final class CartNFTCell: UITableViewCell, ReuseIdentifying {
    weak var delegate: CartNFTCellDelegate?
    
    // MARK: - Private Properties
    private let nftImage: UIImageView = {
        let nftImage = UIImageView()
        nftImage.layer.cornerRadius = 12
        nftImage.layer.masksToBounds = true
        nftImage.contentMode = .scaleAspectFill
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        return nftImage
    }()
    
    private let title: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        title.textColor = .yaWhiteDayNight
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let priceDescription: UILabel = {
        let priceDescription = UILabel()
        priceDescription.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        priceDescription.textColor = .yaWhiteDayNight
        priceDescription.text = TextLabels.CartNFTCell.priceDescription
        priceDescription.translatesAutoresizingMaskIntoConstraints = false
        return priceDescription
    }()
    
    private let price: UILabel = {
        let price = UILabel()
        price.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        price.textColor = .yaWhiteDayNight
        price.translatesAutoresizingMaskIntoConstraints = false
        return price
    }()
    
    private let deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("", for: .normal)
        deleteButton.setImage(UIImage.cartDeleteIcon, for: .normal)
        deleteButton.tintColor = .yaWhiteDayNight
        deleteButton.contentMode = .scaleAspectFit
        deleteButton.addTarget(nil, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
    private let ratingView: StarRatingView = {
        let ratingView = StarRatingView(height: 14)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
    
    private var cartCellModel: CartCellModel?
    private var indexPath: IndexPath?
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configureCell(_ cartCellModel: CartCellModel) {
        let imageURL = cartCellModel.imageURL
        nftImage.kf.setImage(with: imageURL)
        title.text = cartCellModel.title
        price.text = cartCellModel.price
        ratingView.configureRating(cartCellModel.rating)
        self.cartCellModel = cartCellModel
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImage.kf.cancelDownloadTask()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        [nftImage, title, ratingView, priceDescription, price, deleteButton].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: topAnchor, constant: Constants.defaultOffset),
            nftImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.defaultOffset),
            nftImage.widthAnchor.constraint(equalTo: nftImage.heightAnchor),
            
            title.topAnchor.constraint(equalTo: topAnchor, constant: Constants.defaultOffset * 1.5),
            title.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: Constants.defaultOffset * 1.25),
            
            ratingView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Constants.defaultOffset / 4),
            ratingView.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            ratingView.widthAnchor.constraint(equalToConstant: Constants.defaultOffset * 5),
            
            priceDescription.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 12),
            priceDescription.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            
            price.topAnchor.constraint(equalTo: priceDescription.bottomAnchor, constant: Constants.defaultOffset / 8),
            price.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            price.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.defaultOffset * 1.5),
            
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.defaultOffset * 3.125),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.defaultOffset * 3.125)
        ])
    }
    
    @objc private func deleteButtonTapped() {
        guard let cartCellModel else { return }
        self.delegate?.deleteNFTButtonDidTapped(
            with: cartCellModel.id,
            imageURL: cartCellModel.imageURL?.absoluteString ?? "", 
            returnHandler: nil
        )
    }
}

extension CartNFTCell {
    private enum Constants {
        static let defaultOffset: CGFloat = 16
    }
}
