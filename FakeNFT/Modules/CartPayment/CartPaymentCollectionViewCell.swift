//
//  CartPaymentCollectionViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 06.08.2023.
//

import UIKit

final class CartPaymentCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    var currency: CurrencyCellViewModel? {
        didSet {
            self.currencyImageView.image = self.currency?.image

            self.titleLabel.text = self.currency?.title
            self.titleLabel.lineHeight = 18
            self.shortNameLabel.text = self.currency?.name
            self.shortNameLabel.lineHeight = 18
        }
    }

    private let cornerRadius: CGFloat = 12

    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = self.cornerRadius / 2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .red
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .appBlack
        label.font = .getFont(style: .regular, size: 13)
        return label
    }()

    private let shortNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .greenUniversal
        label.font = .getFont(style: .regular, size: 13)
        return label
    }()

    private lazy var selectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = self.cornerRadius
        view.layer.borderColor = UIColor.appBlack.cgColor
        view.layer.borderWidth = 2
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CartPaymentCollectionViewCell {
    func shouldSelectCell(_ shouldSelect: Bool) {
        self.contentView.layer.borderWidth = shouldSelect ? 1 : 0
    }
}

private extension CartPaymentCollectionViewCell {
    func configure() {
        self.contentView.backgroundColor = .appLightGray
        self.contentView.layer.cornerRadius = self.cornerRadius
        self.contentView.layer.borderColor = UIColor.appBlack.cgColor
        self.contentView.layer.borderWidth = 0

        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.contentView.addSubview(self.currencyImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.shortNameLabel)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.currencyImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.currencyImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            self.currencyImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            self.currencyImageView.widthAnchor.constraint(equalTo: self.currencyImageView.heightAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.currencyImageView.trailingAnchor, constant: 4),

            self.shortNameLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.shortNameLabel.leadingAnchor.constraint(equalTo: self.currencyImageView.trailingAnchor, constant: 4)
        ])
    }
}
