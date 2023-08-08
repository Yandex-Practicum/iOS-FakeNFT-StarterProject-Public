//
//  NFTInfoImageCollectionViewCell.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 07.08.2023.
//

import UIKit
import Kingfisher

final class NFTInfoImageCollectionViewCell: UICollectionViewCell {
    struct Configuration {
        let imageUrl: String
    }

    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.contentMode = .scaleAspectFill
        view.layer.maskedCorners = [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner
        ]
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError(
            "NFTInfoImageCollectionViewCell -> init(coder:) has not been implemented"
        )
    }

    private func setupSubviews() {
        contentView.addSubview(image)

        let constraints = [
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with configuration: Configuration) {
        image.kf.setImage(
            with: URL(string: configuration.imageUrl.encodeUrl)
        )
    }
}

