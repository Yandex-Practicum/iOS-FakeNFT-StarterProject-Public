//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import Foundation
import Combine

protocol CatalogCollectionViewModelProtocol: AnyObject {
    //TODO implement in next third of epic after the first review
    var catalogCollection: Catalog { get }
    func calculateCollectionViewHeight() -> CGFloat
}

final class CatalogCollectionViewModel: CatalogCollectionViewModelProtocol {
    //TODO implement in next third of epic after the first review
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
