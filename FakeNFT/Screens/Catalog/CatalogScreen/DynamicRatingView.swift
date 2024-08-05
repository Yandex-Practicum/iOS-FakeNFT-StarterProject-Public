//
//  DynamicRatingView.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//
import UIKit

final class DynamicRatingView: UIStackView {

    private var starsImageView: [UIImageView] = []

    override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )
        commonInit()
    }

    required init(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
        commonInit()
        assertionFailure(
            "init(coder:) has not been implemented"
        )
    }

    func configureRating(
        _ rating: Int
    ) {
        starsImageView.enumerated().forEach {
            index,
            imageView in
            imageView.tintColor = index < rating ? UIColor(
                red: 254/255.0,
                green: 239/255.0,
                blue: 13/255.0,
                alpha: 1
            ) : .lightGray
        }
    }

    private func generateStarView() -> UIImageView {
        let star = UIImageView()
        star.image = UIImage(
            systemName: "star.fill"
        )
        star.contentMode = .scaleAspectFit
        star.tintColor = UIColor(
            red: 254/255.0,
            green: 239/255.0,
            blue: 13/255.0,
            alpha: 1
        )
        star.translatesAutoresizingMaskIntoConstraints = false
        return star
    }

    private func commonInit() {
        axis = .horizontal
        spacing = 2
        distribution = .fillEqually
        for _ in 1...5 {
            let starView = generateStarView()
            starsImageView.append(
                starView
            )
            addArrangedSubview(
                starView
            )
        }
    }
}

extension DynamicRatingView {
    convenience init(
        height: CGFloat
    ) {
        self.init()
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        starsImageView.removeAll()
        axis = .horizontal
        spacing = 2
        distribution = .fillEqually
        for _ in 1...5 {
            let starView = generateStarView(
                with: height
            )
            starsImageView.append(
                starView
            )
            addArrangedSubview(
                starView
            )
        }
    }

    private func generateStarView(
        with height: CGFloat
    ) -> UIImageView {
        let star = UIImageView()
        let pointSize: CGFloat = 3 / 4 * height
        let config = UIImage.SymbolConfiguration(
            pointSize: pointSize
        )
        star.image = UIImage(
            systemName: "star.fill",
            withConfiguration: config
        )
        star.contentMode = .scaleAspectFit
        star.translatesAutoresizingMaskIntoConstraints = false
        return star
    }
}
