//
//  RatingView.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 04.09.2023.
//

import UIKit

final class RatingView: UIView {
    // MARK: - Properties
    private  var  stars: [UIImageView] = []
    private let stackView = UIStackView()

    var rating: Int? {
        didSet {
            config(with: rating)
        }
    }

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RatingView {
    private func setupViews() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        for _ in 1...5 {
            let star = UIImageView()
            stars.append(star)
            stackView.addArrangedSubview(star)
        }
        config(with: nil)
    }

    private func config(with rating: Int?) {
        let rating = rating ?? 0
        for (index, star) in stars.enumerated() {
            if index < rating {
                star.image = UIImage(named: "star_yellow")
            } else {
                star.image = UIImage(named: "star")
            }
        }
    }
}
