//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

final class CartTableViewCell: UITableViewCell, ReuseIdentifying {
    
    var cellModel: CartRow?
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: cellModel?.imageName ?? "")
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: K.Icons.deleteItemFromCart)?
                .withTintColor(
                    .ypBlack ?? .black,
                    renderingMode: .alwaysOriginal
                ),
            for: .normal)
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nftName: CustomLabel = {
        let label = CustomLabel(size: 17, weight: .bold, color: .ypBlack)
        label.text = cellModel?.nftName
        return label
    }()
    
    private lazy var rateStackView: RateStackView = {
        let stackView = RateStackView(rating: cellModel?.rate ?? 0)
        return stackView
    }()
    
    private lazy var nftPriceLabelName: CustomLabel = {
        let label = CustomLabel(size: 15, weight: .regular, color: .ypBlack)
        label.text = NSLocalizedString("Цена", comment: "")
        return label
    }()
    
    private lazy var nftPriceLabel: CustomLabel = {
        let label = CustomLabel(size: 17, weight: .bold, color: .ypBlack)
        label.text = "\(cellModel?.price ?? 99.99) \(cellModel?.coinName ?? "Error")"
        return label
    }()
    
    private lazy var upperCentralStackView: CentralStackView = {
        let stackView = CentralStackView(upperView: nftName, lowerView: rateStackView, spacing: 4)
        return stackView
    }()
    
    private lazy var lowerCentralStackView: CentralStackView = {
        let stackView = CentralStackView(upperView: nftPriceLabelName, lowerView: nftPriceLabel, spacing: 4)
        return stackView
    }()
    
    private lazy var centralStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 12.75
        stackView.distribution = .fillEqually
        
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.addArrangedSubview(upperCentralStackView)
        stackView.addArrangedSubview(lowerCentralStackView)
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.addArrangedSubview(nftImageView)
        stackView.addArrangedSubview(centralStackView)
        stackView.addArrangedSubview(deleteButton)
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        
    }
    
    func applyCellModel(from model: CartRow) {
        cellModel = model
        
    }
    
}

// MARK: - @objc
@objc private extension CartTableViewCell {
    func deleteTapped() {
        print("delete tapped")
    }
}

// MARK: - Ext Constraints
private extension CartTableViewCell {
    func setupConstraints() {
        setupMainStackView()
    }
    
    func setupMainStackView() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
