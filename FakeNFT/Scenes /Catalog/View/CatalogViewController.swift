//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import UIKit
import Combine

final class CatalogViewController: UIViewController {
    
    private var viewModel: CatalogViewModelProtocol!
    private var catalogView: CatalogView!
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        
        button.image = UIImage(named: Constants.sortButtonPicTitle)?.withRenderingMode(.alwaysTemplate)
        button.style = .plain
        button.target = self
        button.action = #selector(sortButtonTapped)
        button.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 9)
        button.tintColor = .black
        
        return button
    }()
    private var subscribes = [AnyCancellable]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
        
        let network = DefaultNetworkClient()
        let service = CatalogService(networkClient: network)
        viewModel = CatalogViewModel(catalogService: service)
        
        catalogView = CatalogView(frame: .zero, viewModel: viewModel, delegate: self)
        self.view = catalogView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCatalogView() {
        let network = DefaultNetworkClient()
        let service = CatalogService(networkClient: network)
        viewModel = CatalogViewModel(catalogService: service)
    }
    
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
        let alertPresenter = AlertPresenter()
        let model = AlertModel(
            message: Constants.filterAlertTitle,
            nameSortText: Constants.filetNameButtonTitle,
            quantitySortText: Constants.filterQuantityButtonTitle,
            cancelButtonText: Constants.closeAlertButtonTitle) { [weak self] in
                guard let self = self else { return }
                print("name")
                viewModel.sortCatalogByName()
            } sortQuantityCompletion: { [weak self] in
                guard let self = self else { return }
                print("qnt")
                viewModel.sortCatalogByQuantity()
            }

        alertPresenter.show(in: self, model: model)
    }
}

extension CatalogViewController: CatalogViewDelegate {
    func selectedCategory(_ model: Catalog) {
        let vc = CatalogCollectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
