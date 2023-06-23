//
//  FavoritedNFTCell.swift
//  FakeNFT
//
//  Created by Илья Валито on 23.06.2023.
//

import UIKit

// MARK: - FavoritedNFTCellDelegate protocol
protocol FavoritedNFTCellDelegate: AnyObject {
    func proceedLike(_ item: FavoritedNFTCell)
}

// MARK: - NFTCell
final class FavoritedNFTCell: UICollectionViewCell {

    // MARK: - Properties and Initializers
    var delegate: FavoritedNFTCellDelegate?

    let nftImageView = UICreator.shared.makeImageView(cornerRadius: 12)
    let nftLikeButton = {
        let button = UICreator.shared.makeButton(cornerRadius: 0, action: #selector(likeTapped))
        button.setImage(UIImage(named: Constants.IconNames.activeLike), for: .normal)
        return button
    }()
    let nftNameLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.bold, withSize: 17))
    let nftRatingStackView =  UICreator.shared.makeStackView(withAxis: .horizontal,
                                                             andSpacing: 2)
    let nftPriceAmountLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.regular, withSize: 15))
    let stackView = UICreator.shared.makeStackView(andSpacing: 24)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Helpers
extension FavoritedNFTCell {

    override func prepareForReuse() {
        nftRatingStackView.arrangedSubviews.forEach {
            nftRatingStackView.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }

    @objc private func likeTapped() {
        delegate?.proceedLike(self)
    }

    private func setupAutolayout() {
        nftImageView.toAutolayout()
        nftLikeButton.toAutolayout()
        nftRatingStackView.toAutolayout()
        stackView.toAutolayout()
    }

    private func addSubviews() {
        addSubview(nftImageView)
        addSubview(nftLikeButton)
        addSubview(nftRatingStackView)
        stackView.addArrangedSubview(nftNameLabel)
        stackView.addArrangedSubview(nftPriceAmountLabel)
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            nftLikeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 5.81),
            nftLikeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -4.81),
            nftLikeButton.widthAnchor.constraint(equalToConstant: 21),
            nftLikeButton.heightAnchor.constraint(equalToConstant: 18),
            nftRatingStackView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            nftRatingStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            stackView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12)
        ])
    }

    func setRating(to rating: Int) {
        for _ in 1...rating {
            let star = UICreator.shared.makeImageView(withImage: Constants.IconNames.activeRating,
                                                      cornerRadius: 0)
            star.widthAnchor.constraint(equalToConstant: 12).isActive = true
            star.heightAnchor.constraint(equalToConstant: 11.25).isActive = true
            nftRatingStackView.addArrangedSubview(star)
        }
        if rating == 5 {
            return
        }
        for _ in (rating + 1)...5 {
            let star = UICreator.shared.makeImageView(withImage: Constants.IconNames.inactiveRating,
                                                      cornerRadius: 0)
            star.widthAnchor.constraint(equalToConstant: 12).isActive = true
            star.heightAnchor.constraint(equalToConstant: 11.25).isActive = true
            nftRatingStackView.addArrangedSubview(star)
        }
    }
}
