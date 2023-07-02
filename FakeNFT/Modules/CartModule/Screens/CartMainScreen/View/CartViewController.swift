//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit
import Combine

protocol CartMainCoordinatableProtocol: AnyObject {
    var onFilter: (() -> Void)? { get set }
    var onDelete: ((String?) -> Void)? { get set }
    var onProceed: (() -> Void)? { get set }
    var onError: ((Error?) -> Void)? { get set }
    func setupFilter(_ filter: CartSortValue)
    func load()
}

final class CartViewController: UIViewController {
    // CartMainCoordinatableProtocol properties
    var onFilter: (() -> Void)?
    var onDelete: ((String?) -> Void)?
    var onProceed: (() -> Void)?
    var onError: ((Error?) -> Void)?

    // Combine
    private var cancellables = Set<AnyCancellable>()
    
    // UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.defaultReuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var loadingView: CustomAnimatedView = {
        let view = CustomAnimatedView(frame: .zero)
        return view
    }()
    
    private lazy var totalNFTCount: CustomLabel = {
        let label = CustomLabel(size: 15, weight: .regular, color: .ypBlack)
        return label
    }()
    
    private lazy var totalToPay: CustomLabel = {
        let label = CustomLabel(size: 17, weight: .bold, color: .universalGreen)
        return label
    }()
    
    private lazy var proceedButton: CustomActionButton = {
        let button = CustomActionButton(title: NSLocalizedString("К оплате", comment: ""), appearance: .confirm)
        button.addTarget(self, action: #selector(proceedTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var totalPurchasesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.addArrangedSubview(totalNFTCount)
        stackView.addArrangedSubview(totalToPay)
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .ypLightGrey
        
        stackView.layer.cornerRadius = 12
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.distribution = .fill
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.heightAnchor.constraint(equalToConstant: 74).isActive = true
        
        stackView.addArrangedSubview(totalPurchasesStackView)
        stackView.addArrangedSubview(proceedButton)
        return stackView
    }()
    
    private lazy var cartStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(infoStackView)
        return stackView
    }()
    
    private lazy var emptyStateLabel: CustomLabel = {
        let label = CustomLabel(size: 17, weight: .bold, color: .ypBlack)
        label.text = NSLocalizedString("Корзина пуста", comment: "")
        label.textAlignment = .center
        return label
    }()
    
    private var diffableDataSource: CartDataSourceManagerProtocol
    private var viewModel: CartViewModel
    
    // MARK: Init
    init(dataSource: CartDataSourceManagerProtocol, viewModel: CartViewModel) {
        self.diffableDataSource = dataSource
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupConstraints()
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
        diffableDataSource.createCartDataSource(for: tableView, with: viewModel.visibleRows)
        diffableDataSource.onDeleteHandler = { [weak self] id in
            self?.onDelete?(id)
        }
    }
    
    private func bind() {
        viewModel.$visibleRows
            .sink { [weak self] rows in
                self?.updateTableView(with: rows)
                self?.updateTotalLabels(from: rows)
                self?.showTheNeededView(for: rows)
            }
            .store(in: &cancellables)
        
        viewModel.$cartError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.onError?(error)
            }
            .store(in: &cancellables)
        
        viewModel.$requestResult.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] requestResult in
                self?.showOrHideAnimation(for: requestResult)
            })
            .store(in: &cancellables)
    }
    
    private func updateTotalLabels(from rows: [NftSingleCollection]) {
        totalNFTCount.text = "\(rows.count) NFT"
        totalToPay.text = "\(rows.compactMap({ $0.price }).reduce(0, +)) ETH"
    }
    
    private func updateTableView(with rows: [NftSingleCollection]) {
        diffableDataSource.updateTableView(with: rows)
    }
    
    private func showTheNeededView(for rows: [NftSingleCollection]) {
        let isLoading = viewModel.requestResult != nil
        cartStackView.isHidden = rows.isEmpty
        emptyStateLabel.isHidden = !rows.isEmpty || isLoading
    }
    
    private func showOrHideAnimation(for requestResult: RequestResult?) {
        
        guard let requestResult
        else {
            loadingView.stopAnimation()
            return
        }
        
        loadingView.result = requestResult
        loadingView.startAnimation()
       
    }
}

// MARK: - Ext CartMainCoordinatableProtocol {
extension CartViewController: CartMainCoordinatableProtocol {
    func setupFilter(_ filter: CartSortValue) {
        viewModel.setupSortValue(filter)
    }
    
    func load() {
        viewModel.load()
    }
}

// MARK: - Ext TableView delegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return diffableDataSource.getRowHeight(for: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .destructive,
            title: NSLocalizedString("Удалить", comment: "")) { [weak self] action, view, handler in
                guard let cell = tableView.cellForRow(at: indexPath) as? CartTableViewCell else { return }
                let id = cell.viewModel?.cartRow.id
                self?.viewModel.deleteItem(with: id)
            }
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
}

// MARK: - Ext OBJC
@objc private extension CartViewController {
    func filterTapped() {
        onFilter?()
    }
    
    func proceedTapped() {
        onProceed?()
    }
}

// MARK: - Ext NavigationBar
private extension CartViewController {
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
private extension CartViewController {
    func setupConstraints() {
        setupCartStackView()
        setupEmptyStackView()
        setupLoadingView()
    }
    
    func setupCartStackView() {
        view.addSubview(cartStackView)
        cartStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cartStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cartStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cartStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cartStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupEmptyStackView() {
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emptyStateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
