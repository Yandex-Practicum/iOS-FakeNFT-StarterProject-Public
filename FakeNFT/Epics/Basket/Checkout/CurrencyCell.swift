//
//  CurrencyCell.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 07/08/2023.
//

import UIKit

final class CurrencyCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let imageBackgroundView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor.ypBlackUniversal
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .ypBlackUniversal
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = UIColor.ypGreenUniversal
        return label
    }()
    
    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: CurrencyModel) {
        if let url = URL(string: model.image) {
            imageView.kf.setImage(with: url)
        }
        titleLabel.text = model.title
        nameLabel.text = model.name
    }

    func select() {
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
    }

    func deselect() {
        contentView.layer.borderWidth = 0
    }
}


private extension CurrencyCell {
    func setupView() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = UIColor.ypLightGrayDay

        [imageBackgroundView, imageView, labelsStackView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        contentView.addSubview(imageBackgroundView)
        contentView.addSubview(imageView)
        contentView.addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(nameLabel)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageBackgroundView.widthAnchor.constraint(equalToConstant: Constants.imageBackgroundSize),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: Constants.imageBackgroundSize),

            imageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),

            labelsStackView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor, constant: 4)
        ])
    }
}

private extension CurrencyCell {
    enum Constants {
        static let imageSize: CGFloat = 31.5
        static let imageBackgroundSize: CGFloat = 36
    }
}

extension CurrencyCell: ReuseIdentifying {}
