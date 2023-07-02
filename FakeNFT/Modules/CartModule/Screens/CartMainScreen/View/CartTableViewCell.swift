//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit
import Combine
import Kingfisher

final class CartTableViewCell: UITableViewCell, ReuseIdentifying {
    
    private var cancellables = Set<AnyCancellable>()
        
    var onDelete: ((String?) -> Void)?
    
    var viewModel: CartCellViewModel? {
        didSet {
            viewModel?.$cartRow
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { newCartRow in
                    self.updateCell(with: newCartRow)
                })
                .store(in: &cancellables)
        }
    }
    
    private var id: String?
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 108).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 108).isActive = true
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
        return label
    }()
    
    private lazy var rateStackView: RateStackView = {
        let stackView = RateStackView()
        return stackView
    }()
    
    private lazy var nftPriceLabelName: CustomLabel = {
        let label = CustomLabel(size: 15, weight: .regular, color: .ypBlack)
        label.text = NSLocalizedString("Цена", comment: "")
        return label
    }()
    
    private lazy var nftPriceLabel: CustomLabel = {
        let label = CustomLabel(size: 17, weight: .bold, color: .ypBlack)
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
        stackView.spacing = 12
        
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
        stackView.distribution = .fill
        stackView.spacing = 20
        
        stackView.layoutMargins = UIEdgeInsets(top: -20, left: 20, bottom: -20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.addArrangedSubview(nftImageView)
        stackView.addArrangedSubview(centralStackView)
        stackView.addArrangedSubview(deleteButton)
        
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rateStackView.removeRating()
        cancellables.forEach({ $0.cancel() })
    }
    
    private func updateCell(with newRow: NftSingleCollection ) {
        nftImageView.kf.setImage(with: URL(string: newRow.images.first ?? ""))
        nftName.text = newRow.name
        rateStackView.addRating(newRow.rating)
        nftPriceLabel.text = "\(newRow.price) ETF"
        id = newRow.id
    }
}

// MARK: - @objc
@objc private extension CartTableViewCell {
    func deleteTapped() {
        onDelete?(id)
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
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
