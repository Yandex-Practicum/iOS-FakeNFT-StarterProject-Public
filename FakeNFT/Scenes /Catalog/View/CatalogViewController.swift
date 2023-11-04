//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import UIKit

final class CatalogViewController: UIViewController {
    
    private let catalogView = CatalogView()
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
    private var viewModel: CatalogViewModelProtocol!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel = CatalogViewModel()
    }
    
    private func setupUI() {
        configureNavBar()
        self.view = catalogView
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
            message: "sort",
            nameSortText: "name",
            quantitySortText: "quantity",
            cancelButtonText: "Cancel") {
                print("name")
            } sortQuantityCompletion: {
                print("qnt")
            }

        alertPresenter.show(in: self, model: model)
    }
}
