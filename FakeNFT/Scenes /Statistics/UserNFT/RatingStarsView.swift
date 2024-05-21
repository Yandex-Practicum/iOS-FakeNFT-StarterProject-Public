//
//  RatingStarsView.swift
//  FakeNFT
//
//  Created by Сергей on 29.04.2024.
//

import UIKit

final class RatingStarsView: UIStackView {
    var rating: Int = 0 {
        didSet {
            updateRating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        spacing = 2
        for _ in 1...5 {
            let starImageView = UIImageView(image: UIImage(named: "starEmpty"))
            starImageView.contentMode = .scaleAspectFit
            addArrangedSubview(starImageView)
        }
    }

    private func updateRating() {
        for (index, subview) in arrangedSubviews.enumerated() {
            if let starImageView = subview as? UIImageView {
                if index < rating {
                    starImageView.image = UIImage(named: "starFilled")
                } else {
                    starImageView.image = UIImage(named: "starEmpty")
                }
            }
        }
    }
}
