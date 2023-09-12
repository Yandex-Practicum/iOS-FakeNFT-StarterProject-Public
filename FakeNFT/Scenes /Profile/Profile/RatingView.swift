//
//  RatingView.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 04.09.2023.
//

import UIKit

final class RatingView: UIView {
    // MARK: - Properties
    private  var  stars: [UIImageView]
    var rating: Int? {
        didSet {
            config(with: rating)
        }
    }

    // MARK: - Initialize
    override init(frame: CGRect) {
        stars = (1...5).map { _ in
            let view = UIImageView()
            view.image = UIImage(named: "star")
            return view
        }
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RatingView {
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: stars)
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
        config(with: nil)
    }

    private func config(with rating: Int?) {
        let rating = rating ?? 0
        stars.enumerated().forEach { offset, star in
            star.tintColor = rating > offset ? .yellow : .gray
        }
    }
}
