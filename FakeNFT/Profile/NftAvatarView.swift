//
//  NftAvatarView.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 04.09.2023.
//
import Kingfisher
import UIKit

final class NftAvatarView: UIView {
    private let imageView = UIImageView()
    private let likeButton = UIButton()

    var viewModel: NftAvatarViewModel? {
        didSet {
            configure(with: viewModel)
        }
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Actions

    @objc private func likeButtonTapped() {
        guard let isLiked = viewModel?.isLiked else { return }
        viewModel?.isLiked = isLiked
        viewModel?.likeButtonAction?()

    }
    // MARK: - Reset to default

    private func reset() {
        imageView.image = nil
        likeButton.tintColor = .ypWhite
        likeButton.setImage(UIImage(systemName: "hear.fill"), for: .normal)
    }

    // MARK: - Setup

    private func setupViews() {
        let radius = CGFloat(12)
        addSubview(imageView)
        addSubview(likeButton)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42)
        ])
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.kf.indicatorType = .activity
    }
}

extension NftAvatarView {
    private func configure(with viewModel: NftAvatarViewModel?) {
        guard let viewModel = viewModel else {
            reset()
            return
        }
        let placeHolder = UIImage(named: "placeHolder")

        imageView.kf.setImage(with: viewModel.imageURL,
        placeholder: placeHolder,
                              options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(1))])
        if let isLiked = viewModel.isLiked {
            likeButton.isHidden = false
            likeButton.tintColor = isLiked ? .ypRed : .ypWhite
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.isHidden = true
        }
    }
}
