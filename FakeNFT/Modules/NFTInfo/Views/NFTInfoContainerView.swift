//
//  NFTInfoContainerView.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 07.08.2023.
//

import UIKit

enum NFTInfoSectionType: Int, CaseIterable {
    case sectionImage = 0
    case sectionDescription
    case sectionItems
}

final class NFTInfoContainerView: UIView {
    enum ViewEventType {
        case toggleFavouriteState(index: Int)
        case selectBin(index: Int)
        case openWebView
    }

    struct ViewConfiguration {
        let nfts: [NFT]
    }

    func configure(with configuration: ViewConfiguration) {
        items = configuration.nfts
    }

    private var imageURL: String
    private var sectionName: String
    private var sectionAuthor: String
    private var sectionDescription: String
    private var items: [NFT] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .null,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let eventHandler: EventHandler<ViewEventType>

    init(imageURL: String,
         sectionName: String,
         sectionAuthor: String,
         sectionDescription: String,
         cellSelected: @escaping (ViewEventType) -> Void) {
        self.eventHandler = cellSelected
        self.imageURL = imageURL
        self.sectionName = sectionName
        self.sectionAuthor = sectionAuthor
        self.sectionDescription = sectionDescription
        super.init(frame: .null)

        configureCollectionView()
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError(
            "NFTInfoContainerView -> init(coder:) has not been implemented"
        )
    }

    private func setupSubViews() {
        backgroundColor = .appWhite

        addSubview(collectionView)

        let constraints = [
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: -100),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func configureCollectionView() {
        collectionView.register(
            NFTInfoImageCollectionViewCell.self,
            forCellWithReuseIdentifier: String(
                describing: NFTInfoImageCollectionViewCell.self
            )
        )
        collectionView.register(
            NFTCollectionDescriptionViewCell.self,
            forCellWithReuseIdentifier: String(
                describing: NFTCollectionDescriptionViewCell.self
            )
        )
        collectionView.register(
            NFTCollectionInfoViewCell.self,
            forCellWithReuseIdentifier: String(
                describing: NFTCollectionInfoViewCell.self
            )
        )

        collectionView.delegate = self
        collectionView.dataSource = self

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        collectionView.setCollectionViewLayout(layout, animated: true)
    }

}

extension NFTInfoContainerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section > 1 ? items.count : 1
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        NFTInfoSectionType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == NFTInfoSectionType.sectionImage.rawValue {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier:
                    String(
                        describing: NFTInfoImageCollectionViewCell.self
                    ),
                for: indexPath
            ) as? NFTInfoImageCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(with: .init(imageUrl: imageURL))
            return cell
        }

        if indexPath.section == NFTInfoSectionType.sectionDescription.rawValue {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(
                    describing: NFTCollectionDescriptionViewCell.self
                ),
                for: indexPath) as? NFTCollectionDescriptionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(
                with: .init(
                    sectionName: sectionName,
                    authorName: sectionAuthor,
                    description: sectionDescription
                )
            )

            cell.eventHandler = { [weak self] in
                self?.eventHandler(.openWebView)
            }

            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(
                describing: NFTCollectionInfoViewCell.self
            ),
            for: indexPath) as? NFTCollectionInfoViewCell else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.row]

        cell.configure(
            with: .init(
                name: item.name,
                rating: item.rating,
                price: item.formattedPrice,
                imageUrl: item.images[0],
                isFavourite: item.isFavourite,
                addedToBasket: item.isSelected
            )
        )

        cell.eventHandler = { [weak self] event in
            switch event {
            case .binClicked:
                self?.eventHandler(
                    .selectBin(index: indexPath.row)
                )

            case .favouriteClicked:
                self?.eventHandler(
                    .toggleFavouriteState(index: indexPath.row)
                )
            }
        }

        return cell
    }
}

extension NFTInfoContainerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRightInset: CGFloat

        if section == NFTInfoSectionType.sectionImage.rawValue {
            leftRightInset = 0
        } else {
            leftRightInset = 16
        }

        return UIEdgeInsets(
            top: 0,
            left: leftRightInset,
            bottom: 0,
            right: leftRightInset
        )
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == NFTInfoSectionType.sectionImage.rawValue {
            return CGSize(width: collectionView.frame.width, height: 310)
        }

        if indexPath.section == NFTInfoSectionType.sectionDescription.rawValue {
            return CGSize(width: collectionView.frame.width - 32, height: 126)
        }

        let layout = collectionViewLayout as? UICollectionViewFlowLayout ?? UICollectionViewFlowLayout()

        let itemWidth = collectionView.frame.width / 3 - layout.minimumInteritemSpacing

        return CGSize(width: itemWidth - 8, height: 172)
    }
}
