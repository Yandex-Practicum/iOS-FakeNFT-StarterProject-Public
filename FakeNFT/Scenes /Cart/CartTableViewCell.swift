//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Svetlana Varenova on 26.11.2025.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func cartCell(_ cell: CartTableViewCell, didChangeRating rating: Int)
    func cartCellDidTapDelete(_ cell: CartTableViewCell)
}

final class CartTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CartTableViewCell"
    
    // MARK: - Delegate
    weak var delegate: CartTableViewCellDelegate?
    
    // MARK: - UI
    
    private let nftImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()
    
    private let ratingStackView = UIStackView()
    private var starButtons: [UIButton] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Bold", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = UIFont(name: "SFProText-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Bold", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .label
        return label
    }()
    
    let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Delete"), for: .normal)
        btn.tintColor = UIColor.segmentButtonBackground
        return btn
    }()
    
    // MARK: - Properties
    private var rating: Int = 0 {
        didSet { updateStars() }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(priceTitleLabel)
        contentView.addSubview(priceValueLabel)
        contentView.addSubview(deleteButton)
        
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 0
        ratingStackView.distribution = .fillEqually
        
        for i in 1...5 {
            let button = UIButton(type: .custom)
            button.tag = i
            button.setImage(UIImage(named: "star_empty"), for: .normal)
            button.setImage(UIImage(named: "star_filled"), for: .selected)
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            
            button.widthAnchor.constraint(equalToConstant: 12).isActive = true
            button.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
            ratingStackView.addArrangedSubview(button)
            starButtons.append(button)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        // MARK: - Constraints
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            
            ratingStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            priceTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceTitleLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 6),
            
            priceValueLabel.leadingAnchor.constraint(equalTo: priceTitleLabel.leadingAnchor),
            priceValueLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            priceValueLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configure
    func configure(with item: NFTItem) {
        nftImageView.image = item.image
        titleLabel.text = item.title
        priceValueLabel.text = "\(item.price) ETH"
        rating = item.rating
    }
    
    // MARK: - Actions
    @objc private func starTapped(_ sender: UIButton) {
        rating = sender.tag
        delegate?.cartCell(self, didChangeRating: rating)
    }
    
    @objc private func deleteTapped() {
        delegate?.cartCellDidTapDelete(self)
    }
    
    private func updateStars() {
        for button in starButtons {
            button.isSelected = button.tag <= rating
        }
    }
}

