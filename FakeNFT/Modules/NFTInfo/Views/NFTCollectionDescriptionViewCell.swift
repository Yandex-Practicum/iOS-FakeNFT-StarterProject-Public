//
//  NFTCollectionDescriptionViewCell.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 07.08.2023.
//

import UIKit

final class NFTCollectionDescriptionViewCell: UICollectionViewCell {
    struct Configuration {
        let sectionName: String
        let authorName: String
        let description: String
    }

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()

    private let horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        return view
    }()

    private let sectionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()

    private let authorLabelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.textColor = .link
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()

    var eventHandler: ExecutionBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError(
            "NFTCollectionDescriptionViewCell -> init(coder:) has not been implemented"
        )
    }

    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(authorClickedHandler)
        )
        authorLabelName.isUserInteractionEnabled = true
        authorLabelName.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func authorClickedHandler() {
        eventHandler?()
    }

    private func setupSubviews() {
        contentView.addSubview(stackView)

        let constraints = [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),

            authorLabel.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        stackView.addArrangedSubview(sectionNameLabel)
        stackView.setCustomSpacing(5, after: sectionNameLabel)
        stackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(authorLabel)
        horizontalStackView.addArrangedSubview(authorLabelName)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    func configure(with configuration: Configuration) {
        sectionNameLabel.text = configuration.sectionName
        authorLabel.text = "COLLECTION_AUTHOR".localized
        authorLabelName.text = configuration.authorName
        descriptionLabel.text = configuration.description
    }
}

