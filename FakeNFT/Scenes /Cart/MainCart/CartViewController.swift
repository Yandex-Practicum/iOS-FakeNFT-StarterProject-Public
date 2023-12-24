//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 10.12.2023.
//

import UIKit
import ProgressHUD

protocol CartViewControllerDelegate: AnyObject {
    func removingNFTsFromCart(id: String)
}

final class CartViewController: UIViewController {
    private let viewModel: CartViewModel
    private var refreshControl = UIRefreshControl()

    // MARK: - UiElements
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.text = NSLocalizedString("Сart.isEmpty", comment: "")
        label.textColor = UIColor(named: "YPBlack")
        label.isHidden = true
        return label
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "YPSort"), for: .normal)
        button.backgroundColor = .clear
        button.isHidden = true
        button.addTarget(CartViewController.self, action: #selector(sortButtonActions), for: .valueChanged)
        return button
    }()

    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("To.pay", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.backgroundColor = UIColor(named: "YPBlack")
        button.addTarget(self, action: #selector(paymentButtonActions), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var quantityNFTLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = UIColor(named: "YPBlack")
        label.text = "0 NFT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.text = "0 ETH"
        label.textColor = UIColor(named: "YPGreen")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var placeholderPaymentView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        view.isHidden = true
        view.backgroundColor = UIColor(named: "YPLightGrey")
        view.addSubview(totalAmountLabel)
        view.addSubview(quantityNFTLabel)
        view.addSubview(paymentButton)
        NSLayoutConstraint.activate([
            quantityNFTLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            quantityNFTLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            totalAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalAmountLabel.topAnchor.constraint(equalTo: quantityNFTLabel.bottomAnchor),
            paymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            paymentButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            paymentButton.widthAnchor.constraint(equalToConstant: 240)
        ])
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()

    // MARK: Initialisation
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configConstraints()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.updateCart()
    }

    // MARK: Binding
    private func bind() {
        viewModel.$nfts.bind(observer: { [weak self] _ in
            guard let self else { return }
            self.screenRenderingLogic()
            self.tableView.reloadData()
        })
    }

    // MARK: - Actions
    @objc private func paymentButtonActions() {
        let defaultNetworkClient = DefaultNetworkClient()
        let serviceCurrency = CurrencyServiceImpl(networkClient: defaultNetworkClient)
        let serviceOrder = OrderServiceImpl(networkClient: defaultNetworkClient)
        let serviceCart = CartServiceImpl(networkClient: defaultNetworkClient)
        let paymentViewModel = PaymentViewModel(
            serviceCurrency: serviceCurrency,
            serviceOrder: serviceOrder,
            serviceCart: serviceCart
        )
        let paymentViewController = PaymentViewController(viewModel: paymentViewModel)
        paymentViewController.modalPresentationStyle = .fullScreen
        present(paymentViewController, animated: true)
    }

    @objc private func sortButtonActions() {
        // TODO: реализовать view для сортировки
    }

    @objc private func refreshData(_ sender: Any) {
        viewModel.updateCart()
        DispatchQueue.main.async {
              self.refreshControl.endRefreshing()
          }
    }

    // MARK: - Private methods
    private func screenRenderingLogic() {
        let nfts = viewModel.nfts
        if nfts.isEmpty {
            cartIsEmpty(empty: true)
        } else {
            cartIsEmpty(empty: false)
            setTotalInfo()
        }
        ProgressHUD.dismiss()
    }

    private func cartIsEmpty(empty: Bool) {
        placeholderLabel.isHidden = !empty
        placeholderPaymentView.isHidden = empty
        sortButton.isHidden = empty
        tableView.isHidden = empty
    }

    private func setTotalInfo() {
        let count = viewModel.nfts.count
        let total = viewModel.countingTheTotalAmount()
        quantityNFTLabel.text = "\(count) NFT"
        totalAmountLabel.text = "\(total) ETH"
    }

    private func configViews() {
        ProgressHUD.show(interaction: false)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        placeholderPaymentView.backgroundColor = UIColor(named: "YPLightGrey")
        view.backgroundColor = UIColor(named: "YPWhite")
        [placeholderLabel, sortButton, tableView, placeholderPaymentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: placeholderPaymentView.topAnchor),
            placeholderPaymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderPaymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderPaymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderPaymentView.heightAnchor.constraint(equalToConstant: 76)
        ])
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.nfts.count
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell
        else { return UITableViewCell() }
        let nft = viewModel.nfts[indexPath.row]
        cell.delegate = self
        cell.configureCell(with: nft)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - CartViewControllerDelegate
extension CartViewController: CartViewControllerDelegate {
    func removingNFTsFromCart(id: String) {
        viewModel.removeItemFromCart(idNFT: id)
    }
}
