//
//  PaymentCell.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 15.12.2023.
//

import UIKit
import Kingfisher

final class PaymentCell: UICollectionViewCell {
    // MARK: - UiElements
    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor(named: "YPBlack")
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor(named: "YPBlack")
        return label
    }()

    private lazy var abbreviationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor(named: "YPGreen")
        return label
    }()

    // MARK: Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "YPLightGrey")
        layer.cornerRadius = 12
        configViews()
        configConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func configureCell(with currency: CurrencyModel) {
        nameLabel.text = currency.title
        abbreviationLabel.text = currency.id
        currencyImageView.image = UIImage(named: currency.image)
    }

    func selectedItem(isSelected: Bool) {
        if isSelected {
            layer.borderWidth = 1
            layer.borderColor = UIColor(named: "YPBlack")?.cgColor
        } else {
            layer.borderWidth = 0
        }
    }

    // MARK: - Private methods
    private func configViews() {
        [currencyImageView, nameLabel, abbreviationLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            currencyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            currencyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36),
            nameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            abbreviationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            abbreviationLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4)
        ])
    }
}
