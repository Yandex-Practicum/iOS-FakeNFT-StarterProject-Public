//
//  NFTDetailsContainerView.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

enum NFTDetailSectionKind: Int, CaseIterable {
    case imageSection = 0
    case descripionSection
    case itemsSection
}

final class NFTDetailsContainerView: UIView {

    private var imageURL: String
    private var sectionName: String
    private var sectionAuthor: String
    private var sectionDescription: String
    private var items: [NFT] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    private let collectionView = UICollectionView(frame: .null, collectionViewLayout: UICollectionViewFlowLayout())

    private let cellSelected: (Action) -> Void

    init(imageURL: String,
         sectionName: String,
         sectionAuthor: String,
         sectionDescription: String,
         cellSelected: @escaping (Action) -> Void) {
        self.cellSelected = cellSelected
        self.imageURL = imageURL
        self.sectionName = sectionName
        self.sectionAuthor = sectionAuthor
        self.sectionDescription = sectionDescription
        super.init(frame: .null)
        setUpCollectionView()
        setupSubViews()
        backgroundColor = .appWhite
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubViews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: -100),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    private func setUpCollectionView() {
        collectionView.register(NFTDetailsImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: NFTDetailsImageCollectionViewCell.reuseIdentifier)
        collectionView.register(NFTDescriptionCollectionViewCell.self,
                                forCellWithReuseIdentifier: NFTDescriptionCollectionViewCell.reuseIdentifier)
        collectionView.register(NFTDetailsCollectionViewCell.self,
                                forCellWithReuseIdentifier: NFTDetailsCollectionViewCell.reuseIdentifier)

        collectionView.delegate = self
        collectionView.dataSource = self

         let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .vertical

        collectionView.setCollectionViewLayout(layout, animated: true)
       }

}

extension NFTDetailsContainerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section <= 1 {
            return 1
        } else {
            return items.count
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        NFTDetailSectionKind.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == NFTDetailSectionKind.imageSection.rawValue {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NFTDetailsImageCollectionViewCell.reuseIdentifier,
                for: indexPath) as? NFTDetailsImageCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(.init(imageUrl: imageURL))
            return cell
        }

        if indexPath.section == NFTDetailSectionKind.descripionSection.rawValue {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NFTDescriptionCollectionViewCell.reuseIdentifier,
                for: indexPath) as? NFTDescriptionCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(.init(sectionName: sectionName,
                                 authorName: sectionAuthor,
                                 description: sectionDescription))

            cell.action = { [weak self] in
                guard let self else { return }
                self.cellSelected(.openWebView)
            }

            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NFTDetailsCollectionViewCell.reuseIdentifier,
            for: indexPath) as? NFTDetailsCollectionViewCell else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.row]

        cell.configure(.init(name: item.name,
                             rating: item.rating,
                             price: item.formattedPrice,
                             imageUrl: item.images[0],
                             isFavourite: item.isFavourite,
                             addedToBasket: item.isSelected))

        cell.action = { [weak self] event in
            guard let self else { return }
            switch event {
            case .tapFavourite:
                self.cellSelected(.selectFavourite(index: indexPath.row))
            case .tapOnBasket:
                self.cellSelected(.selectBasket(index: indexPath.row))
            }
        }

        return cell
    }
}

extension NFTDetailsContainerView: UICollectionViewDelegateFlowLayout {
    /// 1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == NFTDetailSectionKind.imageSection.rawValue {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == NFTDetailSectionKind.imageSection.rawValue {
            return CGSize(width: collectionView.frame.width, height: 310)
        }

        if indexPath.section == NFTDetailSectionKind.descripionSection.rawValue {
            return CGSize(width: collectionView.frame.width - 32, height: 126)
        }

        let lay = collectionViewLayout as? UICollectionViewFlowLayout ?? UICollectionViewFlowLayout()

        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing

        return CGSize(width: widthPerItem - 8, height: 172)
    }
}

extension NFTDetailsContainerView {
    enum Action {
        case selectFavourite(index: Int)
        case selectBasket(index: Int)
        case openWebView
    }
}

extension NFTDetailsContainerView {
    struct Configuration {
        let nfts: [NFT]
    }

    func configure(_ configuration: Configuration) {
        items = configuration.nfts
    }
}
