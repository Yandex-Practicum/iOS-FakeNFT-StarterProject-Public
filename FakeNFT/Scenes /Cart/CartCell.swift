//
//  CartCell.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 25/06/2024.
//

import UIKit

import Combine
import UIKit

final class CartCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    static var defaultReuseIdentifier: String = "CartCell"
    private var cancellables = Set<AnyCancellable>()
    
    private let ratingViewModel: RatingViewModel
    private let ratingView: RatingView
    
    // MARK: - UI Components
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let deleteItemButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "item_delete"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlackDay
        label.text = "Spring"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlackDay
        label.text = "1,78 ETH"
        return label
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .ypBlackDay
        label.text = "Цена"
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                nameLabel,
                ratingView,
                priceTitleLabel,
                priceLabel
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                nftImageView,
                verticalStackView,
                deleteItemButton
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.ratingViewModel = RatingViewModel()
        self.ratingView = RatingView(frame: .zero, viewModel: ratingViewModel)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.ratingViewModel = RatingViewModel()
        self.ratingView = RatingView(frame: .zero, viewModel: ratingViewModel)
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Configuration
    
    func configure(with viewModel: CartCellViewModel) {
        bindViewModel(viewModel)
    }
    
    // MARK: - Bind ViewModel
    
    private func bindViewModel(_ viewModel: CartCellViewModel) {
        viewModel.$viewData
            .receive(on: RunLoop.main)
            .sink { [weak self] viewData in
                self?.nameLabel.text = viewData.name
                self?.priceLabel.text = viewData.price
                self?.ratingViewModel.setRating(viewData.rating)
                self?.nftImageView.image = UIImage(named: viewData.imageURLString)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        contentView.addSubview(mainStackView)
        
        [nftImageView, verticalStackView, deleteItemButton, mainStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            priceTitleLabel.heightAnchor.constraint(equalToConstant: 18),
            priceLabel.heightAnchor.constraint(equalToConstant: 22),
            
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            deleteItemButton.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        setCustomSpacing()
    }
    
    private func setCustomSpacing() {
        verticalStackView.setCustomSpacing(4, after: nameLabel)
        verticalStackView.setCustomSpacing(12, after: ratingView)
        verticalStackView.setCustomSpacing(2, after: priceTitleLabel)
        
        mainStackView.setCustomSpacing(20, after: nftImageView)
        mainStackView.setCustomSpacing(12, after: verticalStackView)
    }
}

