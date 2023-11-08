//
//  CatalogCollectionViewController.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import UIKit

final class CatalogCollectionViewController: UIViewController {
    
    private var catalogCollectionView: CatalogCollectionView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        catalogCollectionView = CatalogCollectionView()
        self.view = catalogCollectionView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
