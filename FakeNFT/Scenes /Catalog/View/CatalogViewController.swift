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
    
//    private let reuseIdentifier = Constants.catalogTableViewCellIdentifier
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        
//        tableView.backgroundColor = .clear
//        tableView.separatorStyle = .none
//        tableView.allowsMultipleSelection = false
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        
//        return tableView
//    }()
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
        
        catalogView = CatalogView(frame: .zero, viewModel: viewModel)
        self.view = catalogView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        viewModel.catalogPublisher.receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                guard let self = self else { return }
//                tableView.reloadData()
//                
//            }.store(in: &subscribes)
//    }
    
    private func setupCatalogView() {
        let network = DefaultNetworkClient()
        let service = CatalogService(networkClient: network)
        viewModel = CatalogViewModel(catalogService: service)
    }
    
    private func setupUI() {
        configureNavBar()
//        view.backgroundColor = .systemBackground
        
//        addSubviews()
//        applyConstraints()
        
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
//    private func addSubviews() {
//        view.addSubview(tableView)
//    }
    
//    private func applyConstraints() {
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
    
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
            cancelButtonText: "Cancel") { [weak self] in
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

//extension CatalogViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.catalog.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CatalogTableViewCell else {
//            return UITableViewCell()
//        }
//        cell.selectionStyle = .none
//        
//        let model = viewModel.catalog[indexPath.row]
//        
//        cell.configureCell(model: model)
//        
//        return cell
//    }
//}
//
//extension CatalogViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 187
//    }
//}
