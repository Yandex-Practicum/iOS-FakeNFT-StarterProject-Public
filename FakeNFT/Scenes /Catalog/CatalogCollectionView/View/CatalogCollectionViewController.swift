//
//  CatalogCollectionViewController.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import UIKit

final class CatalogCollectionViewController: UIViewController {

    // MARK: - Private properties
    private let catalog: Catalog
    private var catalogCollectionView: CatalogCollectionView!
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()

        button.image = UIImage(named: "backward")?.withRenderingMode(.alwaysTemplate)
        button.style = .plain
        button.target = self
        button.action = #selector(backButtonTapped)
        button.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.tintColor = UIColor.nftBlack

        return button
    }()

    init(catalog: Catalog) {
        self.catalog = catalog
        super.init(nibName: nil, bundle: nil)

        let viewModel = CatalogAssembly.buildCatalogCollectionViewModel(catalog: catalog)

        catalogCollectionView = CatalogCollectionView(frame: .zero, viewModel: viewModel, delegate: self)
        self.view = catalogCollectionView

        configureNavBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureNavBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - CatalogCollectionViewDelegate
extension CatalogCollectionViewController: CatalogCollectionViewDelegate {
    func presentAuthorPage(_ url: URL?) {
        let viewModel = WebViewViewModel()
        let view = WebViewController(viewModel: viewModel ,url: url)
        navigationController?.pushViewController(view, animated: true)
    }

    func dismissView() {
        navigationController?.popViewController(animated: true)
    }

    func showErrorAlert() {
        AlertPresenter.showError(in: self) { [weak self] in
            guard let self = self else { return }
            self.catalogCollectionView.reloadData()
        }
    }

    func startAnimatingActivityIndicator() {
        UIBlockingProgressHUD.show()
    }

    func stopAnimatingActivityIndicator() {
        UIBlockingProgressHUD.dismiss()
    }

    func showNftInteractionErrorAlert() {
        AlertPresenter.showNftInteractionError(in: self)
    }
}
