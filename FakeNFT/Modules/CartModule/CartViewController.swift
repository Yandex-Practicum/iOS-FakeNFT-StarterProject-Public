//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

final class CartViewController: UIViewController {
    
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
        label.text = "3 NFT" // TODO: connect to data source
        return label
    }()
    
    private lazy var totalToPay: CustomLabel = {
        let label = CustomLabel(size: 17, weight: .bold, color: .universalGreen)
        label.text = "5,34 ETH" // TODO: connect to data source
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
        
        stackView.addArrangedSubview(totalPurchasesStackView)
        stackView.addArrangedSubview(CustomActionButton(title: NSLocalizedString("К оплате", comment: ""), appearance: .confirm))
        return stackView
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
        
    }
    
    private func createDataSource() {
        dataSource.createDataSource(for: tableView)
    }
}

extension CartViewController: CoordinatableProtocol {
    // TODO: Populate
}

// MARK: - Ext TableView delegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.getRowHeight(for: indexPath)
    }
}

// MARK: - Ext OBJC
@objc private extension CartViewController {
    func filterTapped() {
        print("filter tapped")
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
        setupInfoStackView()
        setupTableView()
       
    }
    
    func setupInfoStackView() {
        view.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoStackView.heightAnchor.constraint(equalToConstant: 76),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            tableView.bottomAnchor.constraint(equalTo: infoStackView.topAnchor)
        ])
    }
}
