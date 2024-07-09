//
//  CurrencyCell.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//

import Combine
import UIKit

final class CurrencyCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cripto_bitcoin")
        imageView.backgroundColor = .ypBlack
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .ypBlackDay
        label.text = "Bitcoin"
        return label
    }()
    
    private let shortNameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .ypGreen
        label.text = "BTC"
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                fullNameLabel,
                shortNameLabel
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                currencyImageView,
                verticalStackView
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSelection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with currency: Currency) {
        currencyImageView.image = UIImage(named: currency.image)
        fullNameLabel.text = currency.title
        shortNameLabel.text = currency.name
    }
    
    private func setupUI() {
        contentView.addSubview(mainStackView)
        
        [
            currencyImageView,
            fullNameLabel,
            shortNameLabel,
            verticalStackView,
            mainStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.backgroundColor = .ypLightGrayDay
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            fullNameLabel.heightAnchor.constraint(equalToConstant: 18),
            shortNameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupSelection() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 12
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? UIColor.ypBlackDay.cgColor : UIColor.clear.cgColor
        }
    }
}

