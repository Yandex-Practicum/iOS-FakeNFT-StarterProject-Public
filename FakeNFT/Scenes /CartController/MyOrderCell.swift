//
//  MyOrderCell.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 05.05.2024.
//

import Foundation
import UIKit
import Kingfisher

protocol CartTableViewCellDelegate: AnyObject {
    func didTapDeleteButton(id: String, image: UIImage)
}

final class MyOrderCell: UITableViewCell {
    
    static let identifier = "MyOrderCell"
    weak var delegate: CartTableViewCellDelegate?
    private var id: String?
    
    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        return cardView
    }()
    
    private lazy var cardImageView: UIImageView = {
        let  cardImageView = UIImageView()
        cardImageView.layer.cornerRadius = 12
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        return  cardImageView
    }()
    
    private lazy var likeImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "")
        image.isHidden = false
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var nameCardLabel: UILabel = {
        let nameCardLabel = UILabel()
        nameCardLabel.text = "April"
        nameCardLabel.font = .bodyBold
        nameCardLabel.textColor = UIColor(named: "Black")
        nameCardLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameCardLabel
    }()
    
    private lazy var starImageView: RatingView = {
        let starImageView = RatingView()
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        return starImageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let trackerNameLabel = UILabel()
        trackerNameLabel.font = .caption2
        trackerNameLabel.text = "Цена"
        trackerNameLabel.textColor = UIColor(named: "Black")
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerNameLabel
    }()
    
    private lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
 //       moneyLabel.text = "1,78 ETH"
        moneyLabel.font = .bodyBold
        moneyLabel.textColor = UIColor(named: "Black")
        moneyLabel.translatesAutoresizingMaskIntoConstraints = false
        return moneyLabel
    }()
    
    private lazy var cartButton: UIButton = {
        let cartButton = UIButton()
        cartButton.setImage(UIImage(named: "cartDelete"), for: .normal)
        cartButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        return cartButton
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupLayout()
        setupLayoutCardView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private  func addSubviews() {
        contentView.addSubview(cardView)
        contentView.addSubview(cartButton)
        
        cardView.addSubview(cardImageView)
        cardView.addSubview(nameCardLabel)
        cardView.addSubview(starImageView)
        cardView.addSubview(priceLabel)
        cardView.addSubview(moneyLabel)
        
        cardImageView.addSubview(likeImageView)
    }
    
    private func setupLayoutCardView() {
        NSLayoutConstraint.activate([
            
            cardImageView.heightAnchor.constraint(equalToConstant: 108),
            cardImageView.widthAnchor.constraint(equalToConstant: 108),
            cardImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            
            likeImageView.heightAnchor.constraint(equalToConstant: 40),
            likeImageView.widthAnchor.constraint(equalToConstant: 40),
            likeImageView.topAnchor.constraint(equalTo: cardImageView.topAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: cardImageView.trailingAnchor),
            
            
            nameCardLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 20),
            nameCardLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            
            starImageView.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 20),
            starImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 34),
            
            priceLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 58),
            
            moneyLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 20),
            moneyLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 78),
        ])
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            cardView.heightAnchor.constraint(equalToConstant: 108),
            cardView.widthAnchor.constraint(equalToConstant: 203),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            cartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func updateCell(with model: NftDataModel) {
        var imageData: UIImage
        
        if UIImage(named: model.images.first!) == nil {
            imageData = UIImage(named: "NFTcard")!
        } else {
            imageData = UIImage(named:model.images.first!)!
        }
        cardImageView.image = imageData
        
        nameCardLabel.text = model.name
        starImageView.setStar(with: model.rating)
        moneyLabel.text = "\(model.price) ETH"
        self.id = model.id
    }
    
    
    @objc private func didTapDeleteButton() {
        
        guard let id = self.id else { return }
        guard let image = cardImageView.image else { return }
        delegate?.didTapDeleteButton(id: id, image: image)
    }
}

