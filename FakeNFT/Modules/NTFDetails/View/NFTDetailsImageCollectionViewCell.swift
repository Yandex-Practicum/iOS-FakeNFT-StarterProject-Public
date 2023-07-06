//
//  NFTDetailsImageCollectionViewCell.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit
import Kingfisher

final class NFTDetailsImageCollectionViewCell: UICollectionViewCell {
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 12
        image.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return image
    }()

    static let reuseIdentifier = description()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(image)

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension NFTDetailsImageCollectionViewCell {
    struct Configuration {
        let imageUrl: String
    }

    func configure(_ configuration: Configuration) {
        let url = URL(string: configuration.imageUrl.encodeUrl)
        image.kf.setImage(with: url)
    }
}
