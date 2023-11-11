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
}

final class CatalogCollectionViewModel: CatalogCollectionViewModelProtocol {
    //TODO implement in next third of epic after the first review
    var catalogCollection: Catalog
    
    init(catalogCollection: Catalog) {
        self.catalogCollection = catalogCollection
    }
}
