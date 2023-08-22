//
//  CollectionScreenMainContentCell.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 17.08.2023.
//

import UIKit
import Kingfisher

final class CollectionScreenMainContentCell: UICollectionViewCell, ReuseIdentifying {
    weak var viewController: CollectionScreenViewControllerProtocol?
    var authorDynamicPartLabelIsEmpty: Bool {
        authorDynamicPartLabel.text?.isEmpty ?? true
    }
    var collectionImageIsEmpty: Bool {
        collectionImage.image == nil
    }
    
    private let collectionImage: UIImageView = {
        let collectionImage = UIImageView()
        collectionImage.contentMode = .scaleAspectFill
        collectionImage.layer.cornerRadius = 12
        collectionImage.layer.masksToBounds = true
        collectionImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        collectionImage.translatesAutoresizingMaskIntoConstraints = false
        return collectionImage
    }()
    private let collectionNameLabel: UILabel = {
        let collectionNameLabel = UILabel()
        collectionNameLabel.text = ""
        collectionNameLabel.font = .headline3
        collectionNameLabel.textColor = .ypBlack
        collectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return collectionNameLabel
    }()
    private let authorStaticPartLabel: UILabel = {
        let authorStaticPartLabel = UILabel()
        authorStaticPartLabel.text = NSLocalizedString("catalog.author", comment: "Статическая надпись, представляющая автора коллекции nft") + " "
        authorStaticPartLabel.font = .caption2
        authorStaticPartLabel.textColor = .ypBlack
        authorStaticPartLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        authorStaticPartLabel.setContentHuggingPriority(.required, for: .horizontal)
        authorStaticPartLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorStaticPartLabel
    }()
    private lazy var authorDynamicPartLabel: UILabel = {
        let authorDynamicPartLabel = UILabel()
        authorDynamicPartLabel.text = ""
        authorDynamicPartLabel.font = .caption1
        authorDynamicPartLabel.textColor = .ypBlueUniversal
        authorDynamicPartLabel.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(authorLabelTap))
        authorDynamicPartLabel.addGestureRecognizer(guestureRecognizer)
        authorDynamicPartLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        authorDynamicPartLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorDynamicPartLabel
    }()
    private let descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.text = ""
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = false
        descriptionTextView.font = .caption2
        descriptionTextView.textColor = .ypBlack
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        return descriptionTextView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollectionImage(link: URL?) {
        collectionImage.kf.setImage(with: link) { [weak self] _ in
            self?.viewController?.viewUpdatedUI()
        }
    }
    
    func setCollectionNameLabel(name: String) {
        collectionNameLabel.text = name
    }
    
    func setAuthorDynamicPartLabel(author: String) {
        authorDynamicPartLabel.text = author
        viewController?.viewUpdatedUI()
    }
    
    func setDescriptionTextView(description: String) {
        descriptionTextView.text = description
    }
    
    private func setView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(collectionImage)
        contentView.addSubview(collectionNameLabel)
        contentView.addSubview(authorStaticPartLabel)
        contentView.addSubview(authorDynamicPartLabel)
        contentView.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            collectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            collectionImage.heightAnchor.constraint(equalToConstant: 310),
            
            collectionNameLabel.topAnchor.constraint(equalTo: collectionImage.bottomAnchor, constant: 16),
            collectionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            authorStaticPartLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorStaticPartLabel.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 13),
            
            authorDynamicPartLabel.leadingAnchor.constraint(equalTo: authorStaticPartLabel.trailingAnchor),
            authorDynamicPartLabel.bottomAnchor.constraint(equalTo: authorStaticPartLabel.bottomAnchor),
            authorDynamicPartLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            authorDynamicPartLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            descriptionTextView.topAnchor.constraint(equalTo: authorStaticPartLabel.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func authorLabelTap() {
        viewController?.authorLabelTap()
    }
}
