//
//  NFTScreenVC+UICollectionViewDataSource.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

extension NFTScreenVC: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NFTScreenCell.identifier, for: indexPath
        ) as? NFTScreenCell else {
            return UICollectionViewCell()
        }

        return cell
    }


}
