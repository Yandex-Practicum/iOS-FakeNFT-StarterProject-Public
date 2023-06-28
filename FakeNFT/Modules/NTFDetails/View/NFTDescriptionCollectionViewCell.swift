//
//  NFTDescriptionCollectionViewCell.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

class NFTDescriptionCollectionViewCell: UICollectionViewCell {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
//        stackView.alignment = .fill
//        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
//        stackView.alignment = .leading
//        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let sectionNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let authorLabelName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.textColor = .link
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    static let reuseIdentifier = description()

    var action: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupSubviews()
        setupGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(authotTapped))
        authorLabelName.isUserInteractionEnabled = true
        authorLabelName.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func authotTapped() {
        action?()
    }

    private func _setupSubviews() {
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        stackView.addArrangedSubview(sectionNameLabel)
        stackView.setCustomSpacing(8, after: sectionNameLabel)
        stackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(authorLabel)
        stackView.setCustomSpacing(8, after: authorLabel)
        horizontalStackView.addArrangedSubview(authorLabelName)
        stackView.addArrangedSubview(descriptionLabel)
    }
}

extension NFTDescriptionCollectionViewCell {
    struct Configuration {
        let sectionName: String
        let authorName: String
        let description: String
    }

    func configure(_ configuration: Configuration) {
        sectionNameLabel.text = configuration.sectionName
        authorLabel.text = "Автор коллекции: "
        authorLabelName.text = configuration.authorName
        descriptionLabel.text = configuration.description
    }
}
