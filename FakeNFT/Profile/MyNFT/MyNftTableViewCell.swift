//
//  MyNftTableViewCell.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 04.09.2023.
//

import UIKit

final class MyNftTableViewCell: UITableViewCell {
    static let identifier = "MyNftTableViewCellidentifier"

    let avatarView = NftAvatarView()
    private let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let ratingView = RatingView()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.text = "от John Doe"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.text = "Цена"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [nameLabel, ratingView, authorLabel])
        stackview.axis = .vertical
        stackview.spacing = 4
        stackview.alignment = .leading
        return stackview
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, priceValueLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground
        layouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureTableView(image: UIImage, rating: Int, name: String, value: Float ) {
        nameLabel.text = name
        ratingView.rating = rating
        priceValueLabel.text = "\(value)"
        avatar.image = image
    }

    private func layouts() {
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(ratingView)
        stackView.addArrangedSubview(authorLabel)

        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceValueLabel)

//        [nameLabel, ratingView, authorLabel].forEach { view in
//            view.translatesAutoresizingMaskIntoConstraints = false
//            stackView.arrangedSubviews(view)
//        }

//        [priceLabel, priceValueLabel].forEach { view in
//            view.translatesAutoresizingMaskIntoConstraints = false
//            priceStackView.arrangedSubviews(view)
//        }

        [avatar, stackView, priceStackView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }

        NSLayoutConstraint.activate([

            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.heightAnchor.constraint(equalToConstant: 108),
            avatar.widthAnchor.constraint(equalToConstant: 108),

            stackView.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 20),

            priceStackView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            priceStackView.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -39),
            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
