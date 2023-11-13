//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import Foundation
import Combine

protocol CatalogCollectionViewModelProtocol: AnyObject {
    var catalogCollection: Catalog { get }
    func calculateCollectionViewHeight() -> CGFloat
}

final class CatalogCollectionViewModel: CatalogCollectionViewModelProtocol {
    var catalogCollection: Catalog

    init(catalogCollection: Catalog) {
        self.catalogCollection = catalogCollection
    }

    func calculateCollectionViewHeight() -> CGFloat {
        let numberOfCells = catalogCollection.nfts.count
        let height = 192
        let spacing = 9
        var result: Int = 0
        if numberOfCells % 3 == 0 {
            result = ((numberOfCells / 3)) * height + ((numberOfCells / 3) * spacing)
        } else {
            result = (numberOfCells / 3 + 1) * height + ((numberOfCells / 3) * spacing)
        }
        return CGFloat(result)
    }
}
