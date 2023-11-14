//
//  GradientCell.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import UIKit

final class GradientView: UIView {

    // MARK: - Private properties
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    // MARK: - Public methods
    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")

        animation.fromValue = [-0.1, 0, 0.1, 0.2, 0.3]
        animation.toValue = [1, 1.1, 1.2, 1.3, 1.4]
        animation.duration = 0.7
        animation.repeatCount = .infinity

        gradientLayer.add(animation, forKey: "locations")
    }

    func stopAnimating() {
        gradientLayer.removeAnimation(forKey: "locations")
    }

    // MARK: - Private methods
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5).cgColor,
            UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5).cgColor,
            UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5).cgColor,
            UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5).cgColor,
            UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5).cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.7)
        gradientLayer.locations = [0.4, 0.5, 0.6]

        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 12
        gradientLayer.masksToBounds = true

        layer.addSublayer(gradientLayer)
    }
}
