//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit
import Combine

protocol CatalogMainScreenCoordinatable: AnyObject {
    var onFilter: (() -> Void)? { get set }
    var onProceed: ((CatalogMainScreenCollection) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    func setupSortDescriptor(_ filter: CollectionSortValue)
}

final class CatalogViewController: UIViewController & Reloadable {

    var onFilter: (() -> Void)?
    var onProceed: ((CatalogMainScreenCollection) -> Void)?
    var onError: ((Error) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.defaultReuseIdentifier)
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var loadingView: CustomAnimatedView = {
        let view = CustomAnimatedView(frame: .zero)
        return view
    }()
    
    let dataSource: GenericTableViewDataSourceProtocol
    let viewModel: CatalogViewModel
    
    // MARK: Init
    init(dataSource: GenericTableViewDataSourceProtocol, viewModel: CatalogViewModel) {
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
        setupRightFilterNavBarItem(title: nil, action: #selector(filterTapped))
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createDataSource()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
    }
    
    // MARK: Bind
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
                self?.catchError(error)
            }
            .store(in: &cancellables)
        
        viewModel.$requestResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requestResult in
                guard let self else { return }
                self.showOrHideAnimation(loadingView, for: requestResult)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Load
    func reload() {
        viewModel.load()
    }
    
    private func catchError(_ error: Error?) {
        guard let error else { return }
        onError?(error)
    }
}

// MARK: - Ext DataSource
private extension CatalogViewController {
    private func createDataSource() {
        dataSource.createDataSource(for: tableView, with: viewModel.visibleRows)
    }
    
    private func updateTableView(with rows: [CatalogMainScreenCollection]) {
        dataSource.updateTableView(with: rows)
    }
}

// MARK: - Ext TableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.getRowHeight(.catalog)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CatalogTableViewCell,
              let collection = cell.viewModel?.catalogRows
        else { return }
        onProceed?(collection)
    }
}

// MARK: - Ext CatalogMainScreenCoordinatable
extension CatalogViewController: CatalogMainScreenCoordinatable {
    func setupSortDescriptor(_ descriptor: CollectionSortValue) {
        viewModel.setupSortValue(descriptor)
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
        setupLoadingView()
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
    
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 75),
            loadingView.widthAnchor.constraint(equalToConstant: 75)
        ])
    }
}
