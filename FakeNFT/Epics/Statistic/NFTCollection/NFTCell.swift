//
//  NFTCell.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 12.08.2023.
//

import UIKit
import Kingfisher
import SnapKit

final class NFTCell: UICollectionViewCell {
    // MARK: - Public
    func configure(with nft: NFT) {
        let addToCart = UIImage.addToBasket?.withTintColor(.ypBlack, renderingMode: .alwaysOriginal)
        let removeFromCart = UIImage.removeFromBasket?.withTintColor(.ypBlack, renderingMode: .alwaysOriginal)
        let grayStar = UIImage.grayStar?.withTintColor(.ypLightGray, renderingMode: .alwaysOriginal)
        nftImageView.image = .mockCell
        let rating = Int(nft.rating)
        ratingStackView.addArrangedSubviews((0..<5).map { UIImageView(image: $0 < rating && rating < 6 ? .yellowStar : grayStar) })
        cartView.image = nft.isInCart ? removeFromCart : addToCart
        nftNameLabel.text = nft.title
        priceLabel.text = "\(nft.price) ETH"
    }

    // MARK: - Private UI Elements
    private let nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private let cartView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .bodyBold
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .caption3
        return label
    }()

    private let container: UIView = {
        let view = UIView()
        return view
    }()

    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()

    private let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()

    private let horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = .zero
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
}

private extension NFTCell {
    private func addSubviews() {
        verticalStackView.addArrangedSubview(nftNameLabel)
        verticalStackView.addArrangedSubview(priceLabel)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(cartView)
        container.addSubview(nftImageView)
        container.addSubview(ratingStackView)
        container.addSubview(horizontalStackView)

        contentView.addSubview(container)
    }

    private func setupConstraints() {
        container.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }

        nftImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(contentView.bounds.width)
        }

        ratingStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nftImageView.snp.bottom).offset(8)
            make.height.equalTo(12)
        }

        horizontalStackView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(container)
            make.top.equalTo(ratingStackView.snp.bottom).offset(4)
            make.height.equalTo(40)
        }

        cartView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
    }
}

extension NFTCell: ReuseIdentifying { }

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
