//
//  MyNftTableViewCell.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 04.09.2023.
//

import UIKit

final class MyNftTableViewCell: UITableViewCell {
    static let identifier = "MyNftTableViewCellidentifier"
    // MARK: - Properties
    let nftView = NftAvatarView()

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

    private lazy var priceValueLabel: UILabel = {
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

    var likeButtonAction: (() -> Void)?

    // MARK: - Initialiser
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground
        layouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func configureMyNftCell(with nft: Nft, isLiked: Bool) {
        nftView.viewModel = NftAvatarViewModel(
            imageURL: nft.images.first,
            isLiked: isLiked,
            likeButtonAction: { [weak self] in
                self?.likeButtonAction?()
            })
        nameLabel.text = nft.name
        ratingView.rating = nft.rating
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        if let formattedPrice = numberFormatter.string(from: NSNumber(value: nft.price)) {
            priceValueLabel.text = "\(formattedPrice) ETH"
        } else {
            priceValueLabel.text = "\(nft.price) ETH"
        }
        nftView.setAI()
    }

    private func layouts() {
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(ratingView)
        stackView.addArrangedSubview(authorLabel)

        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceValueLabel)

        [nftView, stackView, priceStackView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
        NSLayoutConstraint.activate([
            nftView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftView.heightAnchor.constraint(equalToConstant: 108),
            nftView.widthAnchor.constraint(equalToConstant: 108),

            stackView.centerYAnchor.constraint(equalTo: nftView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: nftView.trailingAnchor, constant: 20),

            priceStackView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            priceStackView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -114),
            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
