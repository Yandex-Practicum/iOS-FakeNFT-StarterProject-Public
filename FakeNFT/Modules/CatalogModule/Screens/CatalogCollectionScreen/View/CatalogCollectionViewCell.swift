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
    
    var onLike: ((String?) -> Void)?
    var onCart: ((String?) ->Void)?
    
    var viewModel: CatalogCollectionCellViewModel? {
        didSet {
            viewModel?.$nftRow
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] nftRow in
                    self?.updateCell(with: nftRow)
                })
                .store(in: &cancellables)
        }
    }
    
    private lazy var likeButton: CustomLikeButton = {
        let button = CustomLikeButton(appearance: .normal)
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
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
        stackView.alignment = .center
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
    private func updateCell(with newRow: VisibleSingleNfts ) {
        loadCover(from: newRow.images.first)
        nftName.text = newRow.name
        rateStackView.updateRating(newRow.rating)
        nftPriceLabel.text = "\(newRow.price) ETH"
        id = newRow.id
        updateAddOrDeleteButton(from: newRow)
        updateLikeButton(from: newRow)
    }
    
    private func updateAddOrDeleteButton(from nft: VisibleSingleNfts) {
        addOrDeleteButton.updateAppearence(isInCart: nft.isStored)
    }
    
    private func updateLikeButton(from nft: VisibleSingleNfts) {
        likeButton.updateButtonAppearence(isLiked: nft.isLiked)
    }
    
    private func loadCover(from stringUrl: String?) {
        guard let url = viewModel?.createUrl(from: stringUrl) else { return }
        nftImageView.setImage(from: url)
    }
    
}

// MARK: - Ext @objc
@objc private extension CatalogCollectionViewCell {
    func likeTapped() {
        onLike?(id)
        viewModel?.updateIsLiked()
    }
    
    func cartTapped() {
        onCart?(id)
        viewModel?.updateIsStored()
    }
}

// MARK: - Ext Constraints
private extension CatalogCollectionViewCell {
    func setupConstraints() {
        setupMainStackView()
        setupLabelHeights()
        setupNftImageViewSize()
        setupNamePriceAndButtonStackView()
        setupHeartButton()
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
    }
    
    func setupLabelHeights() {
        NSLayoutConstraint.activate([
            nftName.heightAnchor.constraint(greaterThanOrEqualToConstant: 22),
            nftPriceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 12)
        ])
    }
    
    func setupNftImageViewSize() {
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor)
        ])
    }
    
    func setupNamePriceAndButtonStackView() {
        NSLayoutConstraint.activate([
            namePriceAndButtonStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
    func setupHeartButton() {
        addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
