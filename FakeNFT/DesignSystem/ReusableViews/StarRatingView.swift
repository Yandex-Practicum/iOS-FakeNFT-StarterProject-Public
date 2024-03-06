//
//  StarRatingView.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit

final class StarRatingView: UIStackView {

    private var starImageViews: [UIImageView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        spacing = 2
        distribution = .fillEqually
        for _ in 1...5 {
            let starView = makeStarView()
            starImageViews.append(starView)
            addArrangedSubview(starView)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureRating(_ rating: Int) {
        for (index, imageView) in starImageViews.enumerated() {
            if index < rating {
                imageView.tintColor = .yaYellowUni
            } else {
                imageView.tintColor = .yaLightGreyDayNight
            }
        }
    }

    private func makeStarView() -> UIImageView {
        let star = UIImageView()
        star.image = UIImage(systemName: "star.fill")
        star.contentMode = .scaleAspectFit
        star.translatesAutoresizingMaskIntoConstraints = false
        return star
    }
}

extension StarRatingView {
    convenience init(height: CGFloat) {
        self.init()
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        starImageViews.removeAll()
        axis = .horizontal
        spacing = 2
        distribution = .fillEqually
        for _ in 1...5 {
            let starView = makeStarView(with: height)
            starImageViews.append(starView)
            addArrangedSubview(starView)
        }
    }

    private func makeStarView(with height: CGFloat) -> UIImageView {
        let star = UIImageView()
        let pointSize: CGFloat = 3 / 4 * height
        let config = UIImage.SymbolConfiguration(pointSize: pointSize)
        star.image = UIImage(systemName: "star.fill", withConfiguration: config)
        star.contentMode = .scaleAspectFit
        star.translatesAutoresizingMaskIntoConstraints = false
        return star
    }
}
