//
//  NFTCell.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 12.08.2023.
//

import UIKit
import Kingfisher
import SnapKit
import Combine

final class NFTCell: UICollectionViewCell {
    // MARK: - Public Methods
    func configure(with viewModel: NFTCellViewModel) {
        self.viewModel = viewModel
        let rating = viewModel.rating
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        ratingStackView.addArrangedSubviews((0..<5).map {
            UIImageView(image: $0 < rating && rating < 6 ? .yellowStar : grayStar)
        })
        nftImageView.kf.setImage(with: viewModel.url, placeholder: placeholder)
        addToCardButton.setImage(viewModel.isAddedToCart ? removeFromCart : addToCart, for: .normal)
        likeButton.setImage(viewModel.isLiked ? like : unLike, for: .normal)
        nftNameLabel.text = viewModel.title
        priceLabel.text = viewModel.price

        viewModel.$isLiked
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLiked in
                self?.likeButton.setImage(isLiked ? self?.like : self?.unLike, for: .normal)
            }
            .store(in: &subscriptions)

        viewModel.$isAddedToCart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isInCart in
                self?.addToCardButton.setImage(isInCart ? self?.removeFromCart : self?.addToCart, for: .normal)
            }
            .store(in: &subscriptions)
    }

    // MARK: - Private Properties
    private let nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var addToCardButton: UIButton = {
        let view = UIButton(type: .system)
        view.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return view
    }()

    private lazy var likeButton: UIButton = {
        let view = UIButton(type: .system)
        view.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
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

    // MARK: - Dependencies
    private var viewModel: NFTCellViewModel?
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - View Life Cycles
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptions.removeAll()
        viewModel = nil
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Private Methods
    @objc private func likeButtonTapped(_ sender: UIButton) {
        viewModel?.likeButtonAction.send()
    }

    @objc private func addToCartButtonTapped(_ sender: UIButton) {
        viewModel?.addToCartButtonAction.send()
    }
}

// MARK: - UI
private extension NFTCell {
    private func addSubviews() {
        verticalStackView.addArrangedSubview(nftNameLabel)
        verticalStackView.addArrangedSubview(priceLabel)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(addToCardButton)
        container.addSubview(nftImageView)
        container.addSubview(likeButton)
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

        addToCardButton.snp.makeConstraints { make in
            make.size.equalTo(40)
        }

        likeButton.snp.makeConstraints { make in
            make.size.equalTo(42)
            make.trailing.top.equalToSuperview()
        }
    }
}

extension NFTCell: ReuseIdentifying { }

private extension NFTCell {
    var addToCart: UIImage? {
        UIImage.addToBasket?.withTintColor(.ypBlack, renderingMode: .alwaysOriginal)
    }
    var removeFromCart: UIImage? {
        UIImage.removeFromBasket?.withTintColor(.ypBlack, renderingMode: .alwaysOriginal)
    }
    var grayStar: UIImage? {
        UIImage.grayStar?.withTintColor(.ypLightGray, renderingMode: .alwaysOriginal)
    }
    var placeholder: UIImage? {
        UIImage(systemName: "face.smiling.inverse")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    }
    var like: UIImage? {
        UIImage.liked?.withTintColor(.ypRedUniversal, renderingMode: .alwaysOriginal)
    }
    var unLike: UIImage? {
        UIImage.unliked?.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
}
