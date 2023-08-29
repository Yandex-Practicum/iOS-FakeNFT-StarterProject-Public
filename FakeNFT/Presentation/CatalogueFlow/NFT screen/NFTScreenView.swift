//
//  NFTScreenView.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

final class NFTScreenView: UIView {
    private let coverImage: UIImageView = {
        let view = UIImageView()

        view.backgroundColor = .blue
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        return view
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()

        label.text = "Peach"
        label.font = UIFont(
            name: "SF Pro Text Bold",
            size: 22
        )
        label.textColor = UIColor.NFTColor.black

        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()

        label.text = "Автор коллекции:"
        label.font = UIFont(
            name: "SF Pro Text Regular",
            size: 13
        )
        label.textColor = UIColor.NFTColor.black

        return label
    }()

    let authorLink: UITextView = {
        let textView = UITextView()

        textView.isEditable = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = [.link]

        let attributedString = NSMutableAttributedString(string: "")
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .link: URL(string: "https://example.com")!,
            .foregroundColor: UIColor.red,
            .font: UIFont(
                name: "SF Pro Text Regular",
                size: 15
            )
        ]
        let linkString = NSAttributedString(string: "John Doe", attributes: linkAttributes)
        attributedString.append(linkString)

        textView.attributedText = attributedString

        return textView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()

        label.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
        label.font = UIFont(
            name: "SF Pro Text Regular",
            size: 13
        )
        label.numberOfLines = 4
        label.textColor = UIColor.NFTColor.black

        return label
    }()

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(
            NFTScreenCell.self, forCellWithReuseIdentifier: NFTScreenCell.identifier
        )
        view.backgroundColor = .clear

        return view
    }()

    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        return layout
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func makeView() {
        backgroundColor = UIColor.NFTColor.white

        [
            coverImage,
            headerLabel,
            authorLabel,
            descriptionLabel,
            collectionView,
            authorLink
        ].forEach { item in
            addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(
                equalTo: topAnchor
            ),
            coverImage.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            coverImage.heightAnchor.constraint(
                equalToConstant: 310
            ),
            coverImage.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            headerLabel.topAnchor.constraint(
                equalTo: coverImage.bottomAnchor,
                constant: 16
            ),
            headerLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            authorLabel.topAnchor.constraint(
                equalTo: headerLabel.bottomAnchor,
                constant: 13
            ),
            authorLabel.leadingAnchor.constraint(
                equalTo: headerLabel.leadingAnchor
            ),
            descriptionLabel.topAnchor.constraint(
                equalTo: authorLabel.bottomAnchor,
                constant: 5
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: authorLabel.leadingAnchor
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            collectionView.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: 16
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            authorLink.bottomAnchor.constraint(
                equalTo: authorLabel.bottomAnchor,
                constant: -2
            ),
            authorLink.leadingAnchor.constraint(
                equalTo: authorLabel.trailingAnchor,
                constant: 1
            ),
            authorLink.heightAnchor.constraint(
                equalToConstant: 23
            ),
            authorLink.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            )
        ])
    }
}
