//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

final class CartViewController: UIViewController, CoordinatableProtocol {
    // CoordinatableProtocol properties
    var onProceed: (() -> Void)?
    
    private enum CartState {
        case empty, notEmpty
    }
    
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
        stackView.addArrangedSubview(CustomActionButton(title: NSLocalizedString("К оплате", comment: ""), appearance: .confirm))
        return stackView
    }()
    
    private lazy var cartStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(infoStackView)
        return stackView
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        return view
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
        
    }
    
    private func createDataSource() {
        dataSource.createDataSource(for: tableView, with: viewModel.visibleRows)
    }
    
    private func bind() {
        viewModel.$visibleRows.bind { [weak self] rows in
            self?.dataSource.updateTableView(with: rows)
        }
    }
}

// MARK: - Ext TableView delegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.getRowHeight(for: tableView)
    }
}

// MARK: - Ext OBJC
@objc private extension CartViewController {
    func filterTapped() {
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
}
