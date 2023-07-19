//
//  ProfileMyNftTableViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.07.2023.
//

import UIKit

final class ProfileMyNftTableViewCell: UITableViewCell, ReuseIdentifying {

    var viewModel: ProfileMyNftCellViewModel? {
        didSet {
            bind()
        }
    }
    
    private lazy var nftImageView: NftIMageView = {
        let imageView = NftIMageView(frame: .zero)
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }()
    
    private lazy var likeButton: CustomLikeButton = {
        let button = CustomLikeButton(appearance: .normal)
        return button
    }()
    
    private lazy var nameLabel: CustomLabel = {
        let label = CustomLabel(size: 17, weight: .bold, color: .ypBlack)
        return label
    }()
    
    private lazy var rateStackView: RateStackView = {
        let stackView = RateStackView()
        stackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return stackView
    }()
    
    private lazy var authorNameLabel: CustomLabel = {
        let label = CustomLabel(size: 15, weight: .regular, color: .ypBlack)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        // TODO: add attributes
        return label
    }()
    
    private lazy var priceLabel: CustomLabel = {
        let label = CustomLabel(size: 13, weight: .regular, color: .ypBlack)
        // TODO: add attributes
        return label
    }()
    
    private lazy var nameRateAuthorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
                
        stackView.layoutMargins = UIEdgeInsets(top: contentView.frame.height / 2, left: 0, bottom: contentView.frame.height / 2, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(rateStackView)
        stackView.addArrangedSubview(authorNameLabel)
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        
        stackView.addArrangedSubview(nftImageView)
        stackView.addArrangedSubview(nameRateAuthorStackView)
        stackView.addArrangedSubview(priceLabel)
        return stackView
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel?.$cellModel
            .sink(receiveValue: { [weak self] visibleSingleNft in
                self?.updateUI(with: visibleSingleNft)
            })
            .cancel()
    }
    
    private func updateUI(with nft: VisibleSingleNfts) {
        loadCover(with: nft)
        updateLikeButton(with: nft)
        updateRate(with: nft)
        updateLabels(with: nft)
    }
    
    private func loadCover(with nft: VisibleSingleNfts) {
        let url = viewModel?.createUrl(from: nft.images.first)
        nftImageView.setImage(from: url)
    }
    
    private func updateLikeButton(with nft: VisibleSingleNfts) {
        likeButton.updateButtonAppearence(isLiked: nft.isLiked)
    }
    
    private func updateRate(with nft: VisibleSingleNfts) {
        rateStackView.updateRating(nft.rating)
    }
    
    private func updateLabels(with nft: VisibleSingleNfts) {
        nameLabel.text = nft.name
        authorNameLabel.text = nft.author
        priceLabel.text = "\(nft.price) ETH"
    }
    
}

// MARK: - Ext Constraints
private extension ProfileMyNftTableViewCell {
    func setupConstraints() {
        setupMainstackView()
        setupLikeButton()
    }
    
    func setupMainstackView() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setupLikeButton() {
        addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 45),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor)
        ])
    }
    
}
