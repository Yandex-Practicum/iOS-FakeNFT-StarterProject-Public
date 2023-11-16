//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import UIKit

final class CatalogViewController: UIViewController {

    // MARK: - Private properties
    private var viewModel: CatalogViewModelProtocol!
    private var catalogView: CatalogView!
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()

        button.image = UIImage(resource: .sortButton).withRenderingMode(.alwaysTemplate)
        button.style = .plain
        button.target = self
        button.action = #selector(sortButtonTapped)
        button.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 9)
        button.tintColor = .black

        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()

        viewModel = CatalogAssembly.buildCatalogViewModel()

        catalogView = CatalogView(frame: .zero, viewModel: viewModel, delegate: self)
        self.view = catalogView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private mathods
    private func setupUI() {
        configureNavBar()
    }

    private func configureNavBar() {
        navigationItem.rightBarButtonItem = sortButton
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.shadowImage = UIImage()
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }

    @objc
    private func sortButtonTapped() {
        let model = AlertModel(
            message: L10n.FilterAlert.title,
            nameSortText: L10n.FilterAlert.nameSortTitle,
            quantitySortText: L10n.FilterAlert.quantitySortTitle,
            cancelButtonText: L10n.FilterAlert.cancelButtonTitle) { [weak self] in
                guard let self = self else { return }
                viewModel.sortCatalogByName()
            } sortQuantityCompletion: { [weak self] in
                guard let self = self else { return }
                viewModel.sortCatalogByQuantity()
            }

        AlertPresenter.show(in: self, model: model)
    }
}

// MARK: - CatalogViewControllerDelegate
extension CatalogViewController: CatalogViewDelegate {
    func showErrorAlert() {
        AlertPresenter.showError(in: self) { [weak self] in
            guard let self = self else { return }
            catalogView.reloadData()
        }
    }

    func selectedCategory(_ model: Catalog) {
        let viewController = CatalogCollectionViewController(catalog: model)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }

    func startAnimatingActivityIndicator() {
        UIBlockingProgressHUD.show()
    }

    func stopAnimatingActivityIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
}
