//
//  NFTCell.swift
//  FakeNFT
//
//  Created by Илья Валито on 21.06.2023.
//

import UIKit

// MARK: - NFTCellDelegate protocol
protocol NFTCellDelegate: AnyObject {
    func proceedLike(_ cell: NFTCell)
}

// MARK: - NFTCell
final class NFTCell: UITableViewCell {

    // MARK: - Properties and Initializers
    static let reuseIdentifier = "ProfileNFTCell"
    var delegate: NFTCellDelegate?

    let nftImageView = UICreator.makeImageView(cornerRadius: 12)
    let nftLikeButton = {
        let button = UICreator.makeButton(cornerRadius: 0, action: #selector(likeTapped))
        button.setImage(UIImage(named: Constants.IconNames.inactiveLike), for: .normal)
        return button
    }()
    let nftNameLabel = UICreator.makeLabel(font: UIFont.appFont(.bold, withSize: 17))
    let nftAuthorLabel = UICreator.makeLabel(font: UIFont.appFont(.regular, withSize: 13))
    let nftRatingStackView =  UICreator.makeStackView(withAxis: .horizontal,
                                                             andSpacing: 2)
    let nftPriceLabel = UICreator.makeLabel(text: "PRICE".localized,
                                            font: UIFont.appFont(.regular, withSize: 13))
    let nftPriceAmountLabel = UICreator.makeLabel(font: UIFont.appFont(.bold, withSize: 17))
    let nftRightStackView = UICreator.makeStackView(andSpacing: 2)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Helpers
extension NFTCell {

    @objc private func likeTapped() {
        delegate?.proceedLike(self)
    }

    private func setupAutolayout() {
        nftImageView.toAutolayout()
        nftNameLabel.toAutolayout()
        nftAuthorLabel.toAutolayout()
        nftLikeButton.toAutolayout()
        nftRightStackView.toAutolayout()
        nftRatingStackView.toAutolayout()
    }

    private func addSubviews() {
        addSubview(nftImageView)
        addSubview(nftLikeButton)
        addSubview(nftRatingStackView)
        addSubview(nftNameLabel)
        addSubview(nftAuthorLabel)
        nftRightStackView.addArrangedSubview(nftPriceLabel)
        nftRightStackView.addArrangedSubview(nftPriceAmountLabel)
        addSubview(nftRightStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LocalConstants.defaultSpacing),
            nftImageView.topAnchor.constraint(equalTo: topAnchor, constant: LocalConstants.defaultSpacing),
            nftImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LocalConstants.defaultSpacing),
            nftImageView.heightAnchor.constraint(equalToConstant: LocalConstants.imageSize),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            nftLikeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor,
                                               constant: LocalConstants.likeButtonTopSpacing),
            nftLikeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor,
                                                    constant: -LocalConstants.likeButtonTrailingSpacing),
            nftLikeButton.widthAnchor.constraint(equalToConstant: LocalConstants.likeButtonWidth),
            nftLikeButton.heightAnchor.constraint(equalToConstant: LocalConstants.likeButtonHeight),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor,
                                                  constant: LocalConstants.defaultLeadingSpacing),
            nftNameLabel.topAnchor.constraint(greaterThanOrEqualTo: nftImageView.topAnchor,
                                              constant: LocalConstants.nftNameTopSpacing),
            nftRatingStackView.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor,
                                                    constant: LocalConstants.verticalSpacing),
            nftRatingStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor,
                                                        constant: LocalConstants.defaultLeadingSpacing),
            nftAuthorLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor,
                                                    constant: LocalConstants.defaultLeadingSpacing),
            nftAuthorLabel.topAnchor.constraint(equalTo: nftRatingStackView.bottomAnchor,
                                                constant: LocalConstants.verticalSpacing),
            nftRightStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                        constant: -LocalConstants.rightStackViewTrailingSpacing),
            nftRightStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftRightStackView.widthAnchor.constraint(equalToConstant: LocalConstants.rightStackViewWidth)
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

// MARK: - NFTCell LocalConstants
private enum LocalConstants {

    static let defaultSpacing: CGFloat = 16
    static let defaultLeadingSpacing: CGFloat = 20
    static let imageSize: CGFloat = 108
    static let likeButtonTopSpacing: CGFloat = 12
    static let likeButtonTrailingSpacing: CGFloat = 11.36
    static let likeButtonWidth: CGFloat = 17.64
    static let likeButtonHeight: CGFloat = 15.75
    static let nftNameTopSpacing: CGFloat = 23
    static let verticalSpacing: CGFloat = 4
    static let rightStackViewTrailingSpacing: CGFloat = 39
    static let rightStackViewWidth: CGFloat = 85
    static let starWidth: CGFloat = 12
    static let starHeight: CGFloat = 11.25
}
