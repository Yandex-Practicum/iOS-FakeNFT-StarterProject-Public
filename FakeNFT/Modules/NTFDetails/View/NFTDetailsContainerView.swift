//
//  NFTDetailsContainerView.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

class NFTDetailsContainerView: UIView {
    private let details: NFTDetails

    private let collectionView = UICollectionView(frame: .null, collectionViewLayout: UICollectionViewFlowLayout())

    private let cellSelected: (Action) -> Void

    init(details: NFTDetails, cellSelected: @escaping (Action) -> Void) {
        self.details = details
        self.cellSelected = cellSelected
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
            collectionView.topAnchor.constraint(equalTo: topAnchor),
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
//         layout.minimumLineSpacing = 8
//         layout.minimumInteritemSpacing = 4

        collectionView.setCollectionViewLayout(layout, animated: true)
       }

}

extension NFTDetailsContainerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section <= 1 {
            return 1
        } else {
            return details.items.count
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NFTDetailsImageCollectionViewCell.reuseIdentifier,
                for: indexPath) as? NFTDetailsImageCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(.init(imageUrl: details.imageURL))
            return cell
        }

        if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NFTDescriptionCollectionViewCell.reuseIdentifier,
                for: indexPath) as? NFTDescriptionCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(.init(sectionName: details.sectionName,
                                 authorName: details.sectionAuthor,
                                 description: details.sectionDescription))
            
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

        let item = details.items[indexPath.row]

        cell.configure(.init(name: item.name, rating: item.rating, price: item.price, imageUrl: item.images[0]))

        cell.action = { [weak self] event in
            guard let self else { return }
            switch event {
            case .selectFavourite:
                self.cellSelected(.selectFavourite(index: indexPath.row))
            case .unselectFavourite:
                self.cellSelected(.unselectFavourite(index: indexPath.row))
            case .selectBasket:
                self.cellSelected(.selectBasket(index: indexPath.row))
            case .unselectBasket:
                self.cellSelected(.unselectBasket(index: indexPath.row))
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
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 310)
        }

        if indexPath.section == 1 {
            return CGSize(width: collectionView.frame.width - 32, height: 136)
        }

        let lay = collectionViewLayout as? UICollectionViewFlowLayout ?? UICollectionViewFlowLayout()

        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing

        return CGSize(width: widthPerItem - 8, height: 172)
    }
}

extension NFTDetailsContainerView {
    enum Action {
        case selectFavourite(index: Int)
        case unselectFavourite(index: Int)
        case selectBasket(index: Int)
        case unselectBasket(index: Int)
        case openWebView
    }
}
