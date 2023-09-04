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

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setupViews()
    }

    // MARK: - Actions

    @objc private func likeButtonTapped() {

    }

    private func reset() {
        imageView.image = nil
        likeButton.tintColor = .blue
        likeButton.setImage(UIImage(systemName: "hear.fill"), for: .normal)
    }

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
