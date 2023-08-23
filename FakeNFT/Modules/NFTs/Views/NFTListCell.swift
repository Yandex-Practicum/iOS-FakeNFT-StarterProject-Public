//
//  NFTListCell.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import UIKit
import Kingfisher

final class NFTListCell: UITableViewCell {
    struct Settings {
        let imageUrl: String
        let collectionDescription: String
        let collectionItems: Int
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .appBlack
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appWhite
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        selectionStyle = .none
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError(
            "NFTListCell -> init(coder:) has not been implemented"
        )
    }

    private func setupSubviews() {
        contentView.layer.cornerRadius = 12

        contentView.addSubview(stackView)

        let constraints = [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            image.heightAnchor.constraint(equalToConstant: 140),

            bottomView.heightAnchor.constraint(equalToConstant: 21)
        ]

        NSLayoutConstraint.activate(constraints)

        stackView.addArrangedSubview(image)
        stackView.setCustomSpacing(4, after: image)
        stackView.addArrangedSubview(infoLabel)
        stackView.addArrangedSubview(bottomView)
    }

    func configure(with configuration: Settings) {
        let url = URL(string: configuration.imageUrl.encodeUrl)
        image.kf.setImage(with: url)

        infoLabel.text =
            configuration.collectionDescription +
            " " +
            "(\(configuration.collectionItems))"
    }
}
