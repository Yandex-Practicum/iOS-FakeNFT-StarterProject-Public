//
//  CatalogCollectionViewCell.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 11.11.2023.
//

import UIKit
import Kingfisher

final class CatalogCollectionCell: UICollectionViewCell {

    // MARK: - Public properties
    var nftIsLiked = false
    var nftIsAddedToBasket = false
    weak var delegate: CatalogCollectionCellDelegate?

    // MARK: - private properties
    private let starsQuantity = 5
    private var selectedRate: Int = 0
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let nftImageView: UIImageView = {
        let view = UIImageView()

        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private lazy var likeButton: UIButton = {
        let button = UIButton()

        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    private lazy var starsContainer: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectRate))
        stackView.addGestureRecognizer(tapGesture)

        return stackView
    }()
    private let nftCardNameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.nftBlack
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    private let nftPriceLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.nftBlack
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    private lazy var addToBasketButton: UIButton = {
        let button = UIButton()

        button.addTarget(self, action: #selector(basketButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor.nftBlack, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    private lazy var animationView: UIView = {
        let view = UIView()

        view.isHidden = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .lightGray.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        applyConstraints()

        contentView.backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nftIsLiked = false
        nftIsAddedToBasket = false
        nftImageView.kf.cancelDownloadTask()
        starsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        nftImageView.image = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - public methods
    func createAnimationView() {
        startAnimation()
    }

    func configureCell(_ nft: Nft) {
        let url = nft.images[0]

        nftImageView.kf.setImage(
            with: url,
            placeholder: nil,
            completionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.stopAnimation()
            })

        switchLikeImage()
        switchBasketImage()

        nftCardNameLabel.text = nft.name
        nftPriceLabel.text = "\(String(nft.price)) ETH"
        selectedRate = nft.rating
        createStars()
    }

    func changeLikeState() {
        nftIsLiked = !nftIsLiked
        switchLikeImage()
    }

    func switchBasketState() {
        nftIsAddedToBasket = !nftIsAddedToBasket
        switchBasketImage()
    }

    // MARK: - private methods
    private func addSubviews() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(starsContainer)
        contentView.addSubview(nftCardNameLabel)
        contentView.addSubview(nftPriceLabel)
        contentView.addSubview(addToBasketButton)
        contentView.addSubview(animationView)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // nftImageViewConstraints
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            // likeButton constraints
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),

            // animationView constraints
            animationView.topAnchor.constraint(equalTo: contentView.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 108),
            animationView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

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
            addToBasketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addToBasketButton.heightAnchor.constraint(equalToConstant: 40),
            addToBasketButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func createStars() {
        for index in 1...starsQuantity {
            let star = makeStarIcon()
            star.tag = index
            if index <= selectedRate {
                star.isHighlighted = true
            }
            starsContainer.addArrangedSubview(star)
        }
    }

    private func makeStarIcon() -> UIImageView {
        let imageView = UIImageView(
            image: UIImage(named: "star_inactive")?.withTintColor(UIColor.nftLightgrey),
            highlightedImage: UIImage(named: "star_active")
        )
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }

    private func startAnimation() {
        animationView.isHidden = false
        animationView.addFlashLayer()
    }

    private func stopAnimation() {
        animationView.isHidden = true
    }

    private func switchLikeImage() {
        let image = nftIsLiked ? UIImage(named: "like_active") : UIImage(named: "like_inactive")
        likeButton.setImage(image, for: .normal)
    }

    private func switchBasketImage() {
        let image = nftIsAddedToBasket ?
        UIImage(named: "basket_delete")?.withTintColor(UIColor.nftBlack)
        : UIImage(named: "basket_add")?.withTintColor(UIColor.nftBlack)
        addToBasketButton.setImage(image?.withRenderingMode(.automatic), for: .normal)
    }

    @objc
    private func didTapLikeButton() {
        delegate?.didChangeLike(self)
    }

    @objc
    private func basketButtonTapped() {
        delegate?.switchNftBasketState(self)
    }

    @objc
    private func didSelectRate(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: starsContainer)
        let starWidth = starsContainer.bounds.width / CGFloat(starsQuantity)
        let rate = Int(location.x / starWidth) + 1

        if rate != self.selectedRate {
            feedbackGenerator.selectionChanged()
            self.selectedRate = rate
        }

        starsContainer.arrangedSubviews.forEach { subview in
            guard let starImageView = subview as? UIImageView else {
                return
            }
            starImageView.isHighlighted = starImageView.tag <= rate
        }
    }
}
