//
//  CurrencyCell.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit
import Kingfisher

final class CurrencyCell: UICollectionViewCell, ReuseIdentifying {

    private let background: UIView = {
        let background = UIView()
        background.backgroundColor = .yaLightGreyDayNight
        background.layer.cornerRadius = 12
        background.layer.borderColor = UIColor.yaBlackDayNight.cgColor
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()

    private let currencyImage: UIImageView = {
        let currencyImage = UIImageView()
        currencyImage.backgroundColor = .yaBlackUniversal
        currencyImage.layer.cornerRadius = 6
        currencyImage.layer.masksToBounds = true
        currencyImage.translatesAutoresizingMaskIntoConstraints = false
        return currencyImage
    }()

    private let title: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        title.textColor = .yaBlackDayNight
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    private let ticker: UILabel = {
        let ticker = UILabel()
        ticker.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        ticker.textColor = .yaGreenUniversal
        ticker.translatesAutoresizingMaskIntoConstraints = false
        return ticker
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(cellModel: CurrencyCellModel) {
        let url = URL(string: cellModel.imageURL)
        currencyImage.kf.setImage(with: url)
        title.text = cellModel.title
        ticker.text = cellModel.ticker

        background.layer.borderWidth = cellModel.isSelected ? 1 : 0
    }

    private func setupView() {
        [background, currencyImage, title, ticker].forEach { addSubview($0) }

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            currencyImage.topAnchor.constraint(equalTo: background.topAnchor, constant: Constants.imageOffset),
            currencyImage.leadingAnchor.constraint(
                equalTo: background.leadingAnchor, constant: Constants.defaultLeadingOffset * 3),
            currencyImage.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -Constants.imageOffset),
            currencyImage.widthAnchor.constraint(equalTo: currencyImage.heightAnchor),

            title.topAnchor.constraint(equalTo: currencyImage.topAnchor),
            title.leadingAnchor.constraint(
                equalTo: currencyImage.trailingAnchor, constant: Constants.defaultLeadingOffset),

            ticker.leadingAnchor.constraint(
                equalTo: currencyImage.trailingAnchor, constant: Constants.defaultLeadingOffset),
            ticker.bottomAnchor.constraint(equalTo: currencyImage.bottomAnchor)
        ])
    }
}

extension CurrencyCell {
    private enum Constants {
        static let imageOffset: CGFloat = 5
        static let defaultLeadingOffset: CGFloat = 4
    }
}
