//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit
import Combine

protocol CatalogMainScreenCoordinatable {
    var onFilter: (() -> Void)? { get set }
    var onProceed: (() -> Void)? { get set }
    var onError: ((Error?) -> Void)? { get set }
    func setupSortDescriptor(_ filter: CatalogSortValue)
}

final class CatalogViewController: UIViewController {

    var onFilter: (() -> Void)?
    var onProceed: (() -> Void)?
    var onError: ((Error?) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.defaultReuseIdentifier)
        return tableView
    }()
    
    let dataSource: CatalogDataSourceManagerProtocol
    let viewModel: CatalogViewModel
    
    init(dataSource: CatalogDataSourceManagerProtocol, viewModel: CatalogViewModel) {
        self.dataSource = dataSource
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypLightGrey
        setupConstraints()
        setupNavigationBar()
        createDataSource()
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.forEach({ $0.cancel() })
    }
    
    private func createDataSource() {
        dataSource.createCatalogDataSource(for: tableView, with: viewModel.visibleRows)
    }

    private func bind() {
        viewModel.$visibleRows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] collections in
                self?.updateTableView(with: collections)
            }
            .store(in: &cancellables)
        
        viewModel.$catalogError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.onError?(error)
            }
            .store(in: &cancellables)
    }
    
    private func load() {
        viewModel.load()
    }
    
    private func updateTableView(with rows: [NftCollections]) {
        dataSource.updateTableView(with: rows)
    }
    

}

// MARK: - Ext CatalogMainScreenCoordinatable
extension CatalogViewController: CatalogMainScreenCoordinatable {
    func setupSortDescriptor(_ filter: CatalogSortValue) {
        viewModel.setupSortValue(filter)
    }
}

// MARK: - Ext OBJC
@objc private extension CatalogViewController {
    func filterTapped() {
        onFilter?()
    }
}

// MARK: - Ext NavigationBar
private extension CatalogViewController {
    func setupNavigationBar() {
        setupRightBarButton()
        setupNavBarTitle()
    }
    
    func setupRightBarButton() {
        let rightItem = UIBarButtonItem(
            image: UIImage(systemName: K.Icons.filterRightBarButtonIcon),
            style: .plain,
            target: self,
            action: #selector(filterTapped)
        )
        
        rightItem.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = rightItem
    }
    
    func setupNavBarTitle() {
        navigationController?.navigationBar.topItem?.title = nil
    }
}

// MARK: - Ext Constraints
extension CatalogViewController {
    func setupConstraints() {
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
