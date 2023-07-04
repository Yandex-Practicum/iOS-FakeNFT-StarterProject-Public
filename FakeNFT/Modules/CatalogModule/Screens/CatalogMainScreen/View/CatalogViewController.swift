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
    var onProceed: ((NftCollection) -> Void)? { get set }
    var onError: ((Error?) -> Void)? { get set }
    func setupSortDescriptor(_ filter: CatalogSortValue)
}

final class CatalogViewController: UIViewController {

    var onFilter: (() -> Void)?
    var onProceed: ((NftCollection) -> Void)?
    var onError: ((Error?) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.defaultReuseIdentifier)
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let dataSource: CatalogDataSourceManagerProtocol
    let viewModel: CatalogViewModel
    
    // MARK: Init
    init(dataSource: CatalogDataSourceManagerProtocol, viewModel: CatalogViewModel) {
        self.dataSource = dataSource
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupConstraints()
        setupRightFilterNavBarItem(with: nil, action: #selector(filterTapped))
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
        cancellables.removeAll()
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
    
    private func updateTableView(with rows: [NftCollection]) {
        dataSource.updateTableView(with: rows)
    }
    

}

// MARK: - Ext TableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.getCatalogRowHeight(for: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CatalogTableViewCell,
              let collection = cell.viewModel?.catalogRows
        else { return }
        onProceed?(collection)
        cell.selectionStyle = .none
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

// MARK: - Ext Constraints
extension CatalogViewController {
    func setupConstraints() {
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
