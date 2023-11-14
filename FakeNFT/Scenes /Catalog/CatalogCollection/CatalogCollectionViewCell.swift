//
//  CatalogCollectionViewCell.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 11.11.2023.
//

import UIKit
import Kingfisher

final class CatalogCollectionViewCell: UICollectionViewCell {

    private var selectedRate: Int = 0
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let nftImageView: UIImageView = {
        let view = UIImageView()

        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private lazy var starsContainer: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Adding a UITapGestureRecognizer to our stack of stars to handle clicking on a star
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectRate))
        stackView.addGestureRecognizer(tapGesture)

        return stackView
    }()
    private let nftCardNameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    private let nftPriceLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    private lazy var addToBasketButton: UIButton = {
        let button = UIButton()

        button.setImage(UIImage(named: Constants.addToBasketPicTitle)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(basketButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    private lazy var gradient: GradientView = {
        return GradientView(frame: self.bounds)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createStars()

        addSubviews()
        applyConstraints()

        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(with cardModel: Catalog) { // create new model
//        nftCardNameLabel.text = "Some"
//        nftPriceLabel.text = "1 ETH"
        nftImageView.flash()

//        let url = URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")
//        nftImageView.kf.setImage(with: url)
    }

    func setImage(_ nft: NftModel) {
        let url = nft.images[0]

        nftImageView.kf.setImage(
            with: url,
            placeholder: nil,
            completionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.stopAnimation()
            })

        nftCardNameLabel.text = nft.name
        nftPriceLabel.text = "\(String(nft.price)) ETH"
    }

    private func addSubviews() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(starsContainer)
        contentView.addSubview(nftCardNameLabel)
        contentView.addSubview(nftPriceLabel)
        contentView.addSubview(addToBasketButton)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // nftImageViewConstraints
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),

            // starsContainerConstraints
            starsContainer.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            starsContainer.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            starsContainer.heightAnchor.constraint(equalToConstant: 12),
            starsContainer.widthAnchor.constraint(equalToConstant: 68),

            // nftCardNameLabel constraints
            nftCardNameLabel.topAnchor.constraint(equalTo: starsContainer.bottomAnchor, constant: 4),
            nftCardNameLabel.leadingAnchor.constraint(equalTo: starsContainer.leadingAnchor),
            nftCardNameLabel.heightAnchor.constraint(equalToConstant: 22),

            // nftPriceLabelConstraints
            nftPriceLabel.topAnchor.constraint(equalTo: nftCardNameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftCardNameLabel.leadingAnchor),
            nftPriceLabel.heightAnchor.constraint(equalToConstant: 12),

            // addToBasketButton constraints
            addToBasketButton.topAnchor.constraint(equalTo: nftCardNameLabel.topAnchor),
//            addToBasketButton.leadingAnchor.constraint(equalTo: nftCardNameLabel.trailingAnchor, constant: 10),
            addToBasketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addToBasketButton.heightAnchor.constraint(equalToConstant: 40),
            addToBasketButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func createStars() {
        // loop through the number of our stars and add them to the stackView (starsContainer)
        for index in 1...5 {
            let star = makeStarIcon()
            star.tag = index
            starsContainer.addArrangedSubview(star)
        }
    }

    private func makeStarIcon() -> UIImageView {
        // declare default icon and highlightedImage
        let imageView = UIImageView(
            image: UIImage(named: Constants.starInactivePicTitle),
            highlightedImage: UIImage(named: Constants.starActivePicTitle)
        )
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }

    @objc
    private func basketButtonTapped() {
        addToBasketButton.setImage(UIImage(named: Constants.deleteFromBasketPicTitle), for: .normal)
    }

    @objc
    private func didSelectRate(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: starsContainer)
        let starWidth = starsContainer.bounds.width / CGFloat(5)
        let rate = Int(location.x / starWidth) + 1

        // if current star doesn't match selectedRate then we change our rating
        if rate != self.selectedRate {
            feedbackGenerator.selectionChanged()
            self.selectedRate = rate
        }

        // loop through starsContainer arrangedSubviews and
        // look for all Subviews of type UIImageView and change
        // their isHighlighted state (icons depend on it)
        starsContainer.arrangedSubviews.forEach { subview in
            guard let starImageView = subview as? UIImageView else {
                return
            }
            starImageView.isHighlighted = starImageView.tag <= rate
        }
    }

    func startAnimation() {
        gradient.isHidden = false
        gradient.startAnimating()
    }

    func stopAnimation() {
        gradient.stopAnimating()
        gradient.isHidden = true
    }
}
