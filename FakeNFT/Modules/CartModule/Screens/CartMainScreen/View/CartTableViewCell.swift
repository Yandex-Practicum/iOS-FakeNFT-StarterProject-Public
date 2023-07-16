//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit
import Combine

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
    
    private lazy var nftImageView: NftIMageView = {
        let imageView = NftIMageView(frame: .zero)
        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 108).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 108).isActive = true
        return imageView
    }()
    
    private lazy var deleteButton: CustomAddOrDeleteButton = {
        let button = CustomAddOrDeleteButton(appearance: .delete)
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
        label.text = K.Titles.price
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
        cancellables.removeAll()
    }
    
    private func updateCell(with newRow: SingleNft ) {
        loadCover(from: newRow.images.first)
        nftName.text = newRow.name
        rateStackView.updateRating(newRow.rating)
        nftPriceLabel.text = "\(newRow.price) ETF"
        id = newRow.id
    }
    
    private func loadCover(from stringUrl: String?) {
        guard let url = viewModel?.createUrl(from: stringUrl) else { return }
        nftImageView.setImage(from: url)
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
