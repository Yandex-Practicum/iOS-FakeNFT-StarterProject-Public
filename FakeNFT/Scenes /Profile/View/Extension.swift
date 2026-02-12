//
//  Extension.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 22.01.2026.
//

import UIKit

// MARK: - UIViewController

extension UIViewController {
    func setupBaseNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold),
            .foregroundColor: UIColor.blackApp
        ]
    }
}

// MARK: - UIImageView

extension UIImageView {
    static func baseAvatarImage() -> UIImageView {
        let image = UIImageView()
        image.layer.cornerRadius = 35
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 70),
            image.heightAnchor.constraint(equalToConstant: 70)
        ])
        return image
    }
    
    static func baseNFTImage() -> UIImageView {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }
    
    static func starsImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

// MARK: - UITextView

extension UITextView {
    static func baseTextView() -> UITextView {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.backgroundColor = .lightGreyApp
        textView.layer.cornerRadius = 12
        textView.tintColor = .blackApp
        textView.isScrollEnabled = false
        textView.clipsToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        return textView
    }
}

// MARK: - UILabel

extension UILabel {
    static func baseLabel(
        text: String? = nil,
        font: UIFont = .systemFont(ofSize: 17, weight: .regular),
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = .blackApp
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func emptyStateLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .blackApp
        return label
    }
}

// MARK: - UIStackView

extension UIStackView {
    static func stackVertical(spacing: CGFloat = 8 ,views: [UIView]
    ) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .vertical
        stack.spacing = spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    static func stackHorizontal(spacing: CGFloat = 8,views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.spacing = spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    static func stackVerticalEditProfile(labels: String, field: UIView) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = labels
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .blackApp
        let stack = UIStackView(arrangedSubviews: [titleLabel, field])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }
}

// MARK: - UIButton

extension UIButton {
    static func likeButton(color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = color
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

// MARK: - UIBarButtonItem

extension UIBarButtonItem {
    static func makeButton(image: UIImage, target: Any?, action: Selector?, tintColor: UIColor = .blackApp) -> UIBarButtonItem {
        let button = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        button.tintColor = tintColor
        return button
    }

    static func backButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        return .makeButton(image: UIImage(resource: .backward), target: target, action: action)
    }

    static func sortButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        return .makeButton(image: UIImage(resource: .sort), target: target, action: action)
    }
}
