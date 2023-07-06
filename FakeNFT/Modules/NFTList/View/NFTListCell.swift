//
//  NFTListCell.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit
import Kingfisher

final class NFTListCell: UITableViewCell {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 12
        return image
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    static let reuseIdentifier = description()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.layer.cornerRadius = 12

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            image.heightAnchor.constraint(equalToConstant: 140),

            bottomView.heightAnchor.constraint(equalToConstant: 21)
        ])

        stackView.addArrangedSubview(image)
        stackView.setCustomSpacing(4, after: image)
        stackView.addArrangedSubview(detailsLabel)
        stackView.addArrangedSubview(bottomView)
    }
}

extension NFTListCell {
    struct Configuration {
        let imageUrl: String
        let collectionDescription: String
        let collectionItems: Int
    }

    func configure(_ configuration: Configuration) {
        detailsLabel.text = configuration.collectionDescription + " " + "(\(configuration.collectionItems))"
        let url = URL(string: configuration.imageUrl.encodeUrl)
        image.kf.setImage(with: url)
    }
}
