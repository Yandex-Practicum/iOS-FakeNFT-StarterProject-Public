//
//  CatalogCollectionCellDelegate.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 23.11.2023.
//

import Foundation

protocol CatalogCollectionCellDelegate: AnyObject {
    func didChangeLike(_ cell: CatalogCollectionCell)
    func switchNftBasketState(_ cell: CatalogCollectionCell)
}
