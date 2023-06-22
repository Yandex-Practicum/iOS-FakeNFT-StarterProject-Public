//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

protocol CartMainCoordinatableProtocol {
    var onFilter: (() -> Void)? { get set }
    var onDelete: ((UUID?) -> Void)? { get set }
    var onProceed: (() -> Void)? { get set }
    func setupFilter(_ filter: CartFilter)
}

final class CartViewController: UIViewController {
    // CartMainCoordinatableProtocol properties
    var onFilter: (() -> Void)?
    var onDelete: ((UUID?) -> Void)?
    var onProceed: (() -> Void)?

    // UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.defaultReuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypWhite
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var totalNFTCount: CustomLabel = {
        let label = CustomLabel(size: 15, weight: .regular, color: .ypBlack)
        label.text = "3 NFT" // TODO: connect to data store
        return label
    }()
    
    private lazy var totalToPay: CustomLabel = {
        let label = CustomLabel(size: 17, weight: .bold, color: .universalGreen)
        label.text = "5,34 ETH" // TODO: connect to data store
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
    
    private var dataSource: DataSourceManagerProtocol
    private var viewModel: CartViewModel
    
    // MARK: Init
    init(dataSource: DataSourceManagerProtocol, viewModel: CartViewModel) {
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
        setupNavigationBar()
        setupConstraints()
        createDataSource()
        bind()
        checkEmptyState()
    }
    
    private func createDataSource() {
        dataSource.createDataSource(for: tableView, with: viewModel.getItems())
    }
    
    private func bind() {
        viewModel.$visibleRows.bind { [weak self] rows in
            self?.dataSource.updateTableView(with: rows)
            self?.cartStackView.isHidden = rows.isEmpty
            self?.emptyStateLabel.isHidden = !rows.isEmpty
            
        }
    }
    
    private func checkEmptyState() {
        cartStackView.isHidden = viewModel.visibleRows.isEmpty
        emptyStateLabel.isHidden = !viewModel.visibleRows.isEmpty
    }
}

// MARK: - Ext CartMainCoordinatableProtocol {
extension CartViewController: CartMainCoordinatableProtocol {
    func setupFilter(_ filter: CartFilter) {
        viewModel.chosenFilter = filter
    }
}

// MARK: - Ext TableView delegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.getRowHeight(for: tableView)
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
            cartStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cartStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
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
