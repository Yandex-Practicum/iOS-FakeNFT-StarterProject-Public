//
//  CatalogCollectionViewController.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import UIKit

final class CatalogCollectionViewController: UIViewController {
    private let catalog: Catalog
    private var catalogCollectionView: CatalogCollectionView!

    init(catalog: Catalog) {
        self.catalog = catalog
        super.init(nibName: nil, bundle: nil)

        let viewModel = CatalogAssembly.buildCatalogCollectionViewModel(catalog: catalog)

        catalogCollectionView = CatalogCollectionView(frame: .zero, viewModel: viewModel, delegate: self)
        self.view = catalogCollectionView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CatalogCollectionViewController: CatalogCollectionViewDelegate {
    func dismissView() {
        dismiss(animated: true)
    }

    func showErrorAlert() {
        AlertPresenter.showError(in: self) { [weak self] in
            guard let self = self else { return }
            catalogCollectionView.reloadData()
        }
    }
}
