//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 31.07.2023.
//

import UIKit

final class CartViewController: UIViewController {
    private let cartCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        return collectionView
    }()

    private let purchaseBackgroundView = PurchaseBackgroundView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension CartViewController {
    func configure() {

    }

    func addSubviews() {

    }

    func addConstraints() {

    }
}
