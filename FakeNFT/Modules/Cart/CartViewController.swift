//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 31.07.2023.
//

import UIKit

final class CartViewController: UIViewController {
    private lazy var cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .appWhite
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.delegate = self.tableViewHelper
        tableView.dataSource = self.tableViewHelper
        tableView.register<CartTableViewCell>(CartTableViewCell.self)
        return tableView
    }()

    private let purchaseBackgroundView: PurchaseBackgroundView = {
        let view = PurchaseBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nftCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getFont(style: .regular, size: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let finalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .greenUniversal
        label.font = .getFont(style: .bold, size: 17)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var purchaseButton: AppButton = {
        let button = AppButton(type: .filled, title: "К оплате")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.didTapPurchaseButton), for: .touchUpInside)
        return button
    }()

    private lazy var sortButton: UIBarButtonItem = {
        let image = UIImage.Icons.sort
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(self.didTapSortButton))
        return button
    }()

    private let placeholderView: CartPlaceholderView = {
        let view = CartPlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let progressHUDWrapper = ProgressHUDWrapper()

    private var tableViewHelper: CartTableViewHelperProtocol
    private var viewModel: CartViewModelProtocol

    init(
        viewModel: CartViewModelProtocol,
        tableViewHelper: CartTableViewHelperProtocol
    ) {
        self.viewModel = viewModel
        self.tableViewHelper = tableViewHelper
        super.init(nibName: nil, bundle: nil)

        self.tableViewHelper.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
}

// MARK: - CartTableViewHelperDelegate
extension CartViewController: CartTableViewHelperDelegate {
    var order: [NFTCartCellViewModel]? {
        self.viewModel.order.value
    }
}

private extension CartViewController {
    func configure() {
        self.progressHUDWrapper.show()

        self.view.backgroundColor = .appWhite

        self.addSubviews()
        self.addConstraints()
        self.bind()

        self.viewModel.fetchOrder()
    }

    func addSubviews() {
        self.view.addSubview(self.cartTableView)
        self.view.addSubview(self.purchaseBackgroundView)
        self.view.addSubview(self.placeholderView)

        self.purchaseBackgroundView.addSubview(self.purchaseButton)
        self.purchaseBackgroundView.addSubview(self.nftCountLabel)
        self.purchaseBackgroundView.addSubview(self.finalCostLabel)

        self.navigationItem.rightBarButtonItem = self.sortButton
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.cartTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.cartTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.cartTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.cartTableView.bottomAnchor.constraint(equalTo: self.purchaseBackgroundView.topAnchor),

            self.purchaseBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.purchaseBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.purchaseBackgroundView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.purchaseBackgroundView.heightAnchor.constraint(equalToConstant: 76),

            self.nftCountLabel.topAnchor.constraint(equalTo: self.purchaseBackgroundView.topAnchor, constant: 16),
            self.nftCountLabel.leadingAnchor.constraint(equalTo: self.purchaseBackgroundView.leadingAnchor, constant: 16),
            self.nftCountLabel.trailingAnchor.constraint(equalTo: self.purchaseButton.leadingAnchor, constant: -24),

            self.finalCostLabel.topAnchor.constraint(equalTo: self.nftCountLabel.bottomAnchor, constant: 2),
            self.finalCostLabel.leadingAnchor.constraint(equalTo: self.purchaseBackgroundView.leadingAnchor, constant: 16),
            self.finalCostLabel.trailingAnchor.constraint(equalTo: self.purchaseButton.leadingAnchor, constant: -24),

            self.purchaseButton.topAnchor.constraint(equalTo: self.purchaseBackgroundView.topAnchor, constant: 16),
            self.purchaseButton.trailingAnchor.constraint(equalTo: self.purchaseBackgroundView.trailingAnchor, constant: -16),
            self.purchaseButton.bottomAnchor.constraint(equalTo: self.purchaseBackgroundView.bottomAnchor, constant: -16),

            self.placeholderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.placeholderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.placeholderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.placeholderView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func bind() {
        self.viewModel.order.bind { [weak self] _ in
            self?.cartTableView.reloadData()
        }

        self.viewModel.nftCount.bind { [weak self] nftCount in
            self?.nftCountLabel.text = nftCount
        }

        self.viewModel.finalOrderCost.bind { [weak self] cost in
            self?.finalCostLabel.text = cost
        }

        self.viewModel.shouldHidePlaceholder.bind { [weak self] shouldHide in
            guard let self = self else { return }
            self.progressHUDWrapper.hide()

            self.placeholderView.isHidden = shouldHide
            self.shouldHideSortButton(shouldHide == false)
        }
    }
}

// MARK: - Actions
private extension CartViewController {
    @objc
    func didTapPurchaseButton() {
        print(#function)
    }

    @objc
    func didTapSortButton() {
        print(#function)
    }
}

private extension CartViewController {
    func shouldHideSortButton(_ shouldHide: Bool) {
        if shouldHide {
            self.navigationItem.setRightBarButton(nil, animated: true)
        } else {
            self.navigationItem.setRightBarButton(self.sortButton, animated: true)
        }
    }
}
