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
    var delegate: NFTCellDelegate?

    let nftImageView = UICreator.shared.makeImageView(cornerRadius: 12)
    let nftLikeButton = {
        let button = UICreator.shared.makeButton(cornerRadius: 0, action: #selector(likeTapped))
        button.setImage(UIImage(named: Constants.IconNames.inactiveLike), for: .normal)
        return button
    }()
    let nftNameLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.bold, withSize: 17))
    let nftAuthorLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.regular, withSize: 13))
    let nftRatingStackView =  UICreator.shared.makeStackView(withAxis: .horizontal,
                                                             andSpacing: 2)
    let nftPriceLabel = UICreator.shared.makeLabel(text: "PRICE".localized, font: UIFont.appFont(.regular, withSize: 13))
    let nftPriceAmountLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.bold, withSize: 17))
    let nftLeftStackView = UICreator.shared.makeStackView(andSpacing: 21)
    let nftRightStackView = UICreator.shared.makeStackView(andSpacing: 2)

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
        nftLikeButton.toAutolayout()
        nftLeftStackView.toAutolayout()
        nftRightStackView.toAutolayout()
        nftRatingStackView.toAutolayout()
    }

    private func addSubviews() {
        addSubview(nftImageView)
        addSubview(nftLikeButton)
        addSubview(nftRatingStackView)
        nftLeftStackView.addArrangedSubview(nftNameLabel)
        nftLeftStackView.addArrangedSubview(nftAuthorLabel)
        addSubview(nftLeftStackView)
        nftRightStackView.addArrangedSubview(nftPriceLabel)
        nftRightStackView.addArrangedSubview(nftPriceAmountLabel)
        addSubview(nftRightStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            nftLikeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 12),
            nftLikeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -11.36),
            nftLikeButton.widthAnchor.constraint(equalToConstant: 17.64),
            nftLikeButton.heightAnchor.constraint(equalToConstant: 15.75),
            nftRatingStackView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            nftRatingStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftLeftStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftLeftStackView.trailingAnchor.constraint(equalTo: nftRightStackView.leadingAnchor, constant: -4),
            nftLeftStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftRightStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -39),
            nftRightStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftRightStackView.widthAnchor.constraint(equalToConstant: 85)
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
