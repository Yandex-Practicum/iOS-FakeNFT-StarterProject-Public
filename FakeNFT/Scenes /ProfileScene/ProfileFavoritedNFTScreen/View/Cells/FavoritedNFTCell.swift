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
    static let reuseIdentifier = "ProfileFavoritedNFTCell"
    var delegate: FavoritedNFTCellDelegate?

    let nftImageView = UICreator.makeImageView(cornerRadius: 12)
    let nftLikeButton = {
        let button = UICreator.makeButton(cornerRadius: 0, action: #selector(likeTapped))
        button.setImage(UIImage(named: Constants.IconNames.activeLike), for: .normal)
        return button
    }()
    let nftNameLabel = UICreator.makeLabel(font: UIFont.appFont(.bold, withSize: 17))
    let nftRatingStackView =  UICreator.makeStackView(withAxis: .horizontal,
                                                             andSpacing: 2)
    let nftPriceAmountLabel = UICreator.makeLabel(font: UIFont.appFont(.regular, withSize: 15))
    let stackView = UICreator.makeStackView(andSpacing: 24)

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
            nftImageView.heightAnchor.constraint(equalToConstant: LocalConstants.nftImageSize),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            nftLikeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor,
                                               constant: LocalConstants.nftImageTopSpacing),
            nftLikeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor,
                                                    constant: -LocalConstants.nftImageTrailingSpacing),
            nftLikeButton.widthAnchor.constraint(equalToConstant: LocalConstants.likeWidth),
            nftLikeButton.heightAnchor.constraint(equalToConstant: LocalConstants.likeHeight),
            nftRatingStackView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            nftRatingStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor,
                                                        constant: LocalConstants.defaultLeadingSpacing),
            stackView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor,
                                               constant: LocalConstants.defaultLeadingSpacing),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setRating(to rating: Int) {
        for _ in 1...rating {
            addStar(withState: Constants.IconNames.activeRating)
        }
        if rating == 5 {
            return
        }
        for _ in (rating + 1)...5 {
            addStar(withState: Constants.IconNames.inactiveRating)
        }
    }

    private func addStar(withState ratingState: String) {
        let star = UICreator.makeImageView(withImage: ratingState,
                                           cornerRadius: 0)
        if ratingState == Constants.IconNames.inactiveRating {
            star.image = star.image?.withTintColor(.appLightGray)
        }
        star.widthAnchor.constraint(equalToConstant: LocalConstants.starWidth).isActive = true
        star.heightAnchor.constraint(equalToConstant: LocalConstants.starHeight).isActive = true
        nftRatingStackView.addArrangedSubview(star)
    }
}

// MARK: - FavoritedNFTCell LocalConstants
private enum LocalConstants {

    static let nftImageSize: CGFloat = 80
    static let nftImageTopSpacing: CGFloat = 5.81
    static let nftImageTrailingSpacing: CGFloat = 4.81
    static let likeHeight: CGFloat = 18
    static let likeWidth: CGFloat = 21
    static let defaultLeadingSpacing: CGFloat = 12
    static let starWidth: CGFloat = 12
    static let starHeight: CGFloat = 11.25
}
