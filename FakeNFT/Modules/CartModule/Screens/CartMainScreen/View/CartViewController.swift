//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit
import Combine

protocol CartMainCoordinatableProtocol {
    var onFilter: (() -> Void)? { get set }
    var onDelete: ((UUID?) -> Void)? { get set }
    var onProceed: (() -> Void)? { get set }
    func setupFilter(_ filter: CartSortValue)
}

final class CartViewController: UIViewController {
    // CartMainCoordinatableProtocol properties
    var onFilter: (() -> Void)?
    var onDelete: ((UUID?) -> Void)?
    var onProceed: (() -> Void)?

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
    
    private var diffableDataSource: DataSourceManagerProtocol
    private var viewModel: CartViewModel
    
    // MARK: Init
    init(dataSource: DataSourceManagerProtocol, viewModel: CartViewModel) {
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
        bind()
        setupNavigationBar()
        setupConstraints()
        createDataSource()
        checkEmptyState()
    }
    
    private func createDataSource() {
        diffableDataSource.createDataSource(for: tableView, with: viewModel.visibleRows)
    }
    
    private func bind() {
        viewModel.$visibleRows
            .sink { [weak self] rows in
                self?.diffableDataSource.updateTableView(with: rows)
                self?.updateTotalLabels(from: rows)
                self?.cartStackView.isHidden = rows.isEmpty
                self?.emptyStateLabel.isHidden = !rows.isEmpty
            }
            .store(in: &cancellables)
    }
    
    private func checkEmptyState() {
        cartStackView.isHidden = viewModel.visibleRows.isEmpty
        emptyStateLabel.isHidden = !viewModel.visibleRows.isEmpty
    }
    
    private func updateTotalLabels(from rows: [CartRow]) {
        totalNFTCount.text = "\(rows.count) NFT"
        totalToPay.text = "\(rows.compactMap({ $0.price }).reduce(0, +)) ETH"
    }
}

// MARK: - Ext CartMainCoordinatableProtocol {
extension CartViewController: CartMainCoordinatableProtocol {
    func setupFilter(_ filter: CartSortValue) {
        viewModel.setupSortValue(filter)
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
}

// MARK: - Ext CartCellDelegate
extension CartViewController: CartCellDelegate {
    func didDeletedItem(with id: UUID?) {
        onDelete?(id)
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
}
