//
//  CatalogCollectionViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 03.07.2023.
//

import UIKit
import Combine

final class CatalogCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    private var cancellables = Set<AnyCancellable>()
    private var id: String?
    
    var viewModel: CatalogCollectionCellViewModel? {
        didSet {
            viewModel?.$nftRow
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { nftRow in
                    self.updateCell(with: nftRow)
                })
                .store(in: &cancellables)
        }
    }
    
    private lazy var heartButton: CustomHeartButton = {
        let button = CustomHeartButton(appearance: .normal)
        return button
    }()
    
    private lazy var nftImageView: NftIMageView = {
        let imageView = NftIMageView(frame: .zero)
        return imageView
    }()
    
    private lazy var rateStackView: RateStackView = {
        let stackView = RateStackView()
        return stackView
    }()
    
    private lazy var nftName: CustomLabel = {
        let label = CustomLabel(size: 17, weight: .bold, color: .ypBlack)
        return label
    }()
    
    private lazy var nftPriceLabel: CustomLabel = {
        let label = CustomLabel(size: 10, weight: .medium, color: .ypBlack)
        return label
    }()
    
    private lazy var addOrDeleteButton: CustomAddOrDeleteButton = {
        let button = CustomAddOrDeleteButton(appearance: .add)
        return button
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        
        stackView.addArrangedSubview(nftName)
        stackView.addArrangedSubview(nftPriceLabel)
        
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return stackView
    }()
    
    private lazy var namePriceAndButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.addArrangedSubview(labelsStackView)
        stackView.addArrangedSubview(addOrDeleteButton)
        return stackView
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubview(rateStackView)
        stackView.addArrangedSubview(namePriceAndButtonStackView)
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.addArrangedSubview(nftImageView)
        stackView.addArrangedSubview(bottomStackView)
        return stackView
    }()
    
    
    // MARK: Lifecycle
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
    
    // MARK: Methods
    private func updateCell(with newRow: SingleNft ) {
        loadCover(from: newRow.images.first)
        nftName.text = newRow.name
        rateStackView.addRating(newRow.rating)
        nftPriceLabel.text = "\(newRow.price) ETH"
        id = newRow.id
    }
    
    private func loadCover(from stringUrl: String?) {
        guard
            let nftUrl = stringUrl,
            let encodedStringUrl = nftUrl.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(string: encodedStringUrl)
        else {
            return
        }
        
        nftImageView.setImage(from: url)
    }
    
}

// MARK: - Ext Constraints
private extension CatalogCollectionViewCell {
    func setupConstraints() {
        setupMainStackView()
    }
    
    func setupMainStackView() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            nftName.heightAnchor.constraint(greaterThanOrEqualToConstant: 22),
            nftPriceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 12),
            addOrDeleteButton.trailingAnchor.constraint(equalTo: namePriceAndButtonStackView.trailingAnchor),
            namePriceAndButtonStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
}
