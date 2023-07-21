//
//  ProfileLikedNftsCollectionCell.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 21.07.2023.
//

import UIKit

final class ProfileLikedNftsCollectionCell: UICollectionViewCell, ReuseIdentifying {
    var viewModel: ProfileLikedNftsCellViewModel? {
        didSet {
            bind()
        }
    }
    
    private lazy var likeButton: CustomLikeButton = {
        let button = CustomLikeButton(appearance: .normal)
        return button
    }()
    
    private lazy var nftImageView: NftIMageView = {
        let imageView = NftIMageView(frame: .zero)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
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
        let label = CustomLabel(size: 15, weight: .regular, color: .ypBlack)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()
    
    private lazy var nameRatePriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
        
        stackView.addArrangedSubview(nftName)
        stackView.addArrangedSubview(rateStackView)
        stackView.addArrangedSubview(nftPriceLabel)
        stackView.addArrangedSubview(UIView())
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.addArrangedSubview(nftImageView)
        stackView.addArrangedSubview(nameRatePriceStackView)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel?.$cellModel
            .sink(receiveValue: { [weak self] likedNfts in
                self?.updateUI(with: likedNfts)
            })
            .cancel()
    }
}
// MARK: - Ext UpdateUI
private extension ProfileLikedNftsCollectionCell {
    func updateUI(with nft: LikedSingleNfts) {
        loadCover(with: nft)
        updateLikeButton(with: nft)
        updateRate(with: nft)
        updateLabels(with: nft)
    }
    
    func loadCover(with nft: LikedSingleNfts) {
        let url = viewModel?.createUrl(from: nft.images.first)
        nftImageView.setImage(from: url)
    }
    
    func updateLikeButton(with nft: LikedSingleNfts) {
        likeButton.updateButtonAppearence(isLiked: nft.isLiked)
    }
    
    func updateRate(with nft: LikedSingleNfts) {
        rateStackView.updateRating(nft.rating)
    }
    
    func updateLabels(with nft: LikedSingleNfts) {
        nftName.text = nft.name
        nftPriceLabel.text = "\(nft.price) ETH"
    }
}

// MARK: - Ext Constraints
private extension ProfileLikedNftsCollectionCell {
    func setupConstraints() {
        setupMainStackView()
        setupLikeButton()
    }
    
    func setupMainStackView() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupLikeButton() {
        addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.heightAnchor.constraint(lessThanOrEqualToConstant: 30),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor)
        ])
    }
}
