//
//  SiteCellView.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import UIKit
import SnapKit

final class SiteCellView: UICollectionViewCell {
    // MARK: - Private Properties
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.ypBlack.cgColor
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.text = "Перейти на сайт пользователя"
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
}

// MARK: - UI
private extension SiteCellView {
    func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(label)
    }

    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension SiteCellView: ReuseIdentifying { }

// MARK: - Animation
extension SiteCellView: AnimatableCollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            highlightAnimation()
        }
    }
}

// MARK: - Dark, White theme
extension SiteCellView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            containerView.layer.borderColor = UIColor.ypBlack.cgColor
        }
    }
}
