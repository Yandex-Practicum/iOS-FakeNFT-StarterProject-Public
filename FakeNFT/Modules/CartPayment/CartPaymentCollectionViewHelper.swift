//
//  CartPaymentCollectionViewHelper.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 06.08.2023.
//

import UIKit

protocol CartPaymentCollectionViewHelperDelegate: AnyObject {

}

protocol CartPaymentCollectionViewHelperProtocol: UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: CartPaymentCollectionViewHelperDelegate? { get set }
}

final class CartPaymentCollectionViewHelper: NSObject {
    weak var delegate: CartPaymentCollectionViewHelperDelegate?
}

// MARK: - CartPaymentCollectionViewHelperProtocol
extension CartPaymentCollectionViewHelper: CartPaymentCollectionViewHelperProtocol {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
