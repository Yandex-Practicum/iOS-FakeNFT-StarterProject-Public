//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 31.07.2023.
//

import UIKit

final class CartViewController: UIViewController {
    private let cartView = CartView()

    private lazy var sortButton: UIBarButtonItem = {
        let image = UIImage.Icons.sort
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(self.didTapSortButton))
        return button
    }()

    private var tableViewHelper: CartTableViewHelperProtocol
    private var viewModel: CartViewModelProtocol

    init(
        viewModel: CartViewModelProtocol,
        tableViewHelper: CartTableViewHelperProtocol
    ) {
        self.viewModel = viewModel
        self.tableViewHelper = tableViewHelper
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    override func loadView() {
        self.view = self.cartView
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
        ProgressHUDWrapper.show()

        self.configureView()
        self.bind()
        self.viewModel.fetchOrder()

        self.navigationItem.rightBarButtonItem = self.sortButton
    }

    func bind() {
        self.viewModel.order.bind { [weak self] _ in
            self?.cartView.reloadTableView()
        }

        self.viewModel.nftCount.bind { [weak self] nftCount in
            self?.cartView.setNftCount(nftCount)
        }

        self.viewModel.finalOrderCost.bind { [weak self] cost in
            self?.cartView.setFinalOrderCost(cost)
        }

        self.viewModel.cartViewState.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .empty:
                ProgressHUDWrapper.hide()
                self.cartView.shouldHidePlaceholder(false)
                self.shouldHideSortButton(true)
            case .loaded:
                ProgressHUDWrapper.hide()
                self.cartView.shouldHidePlaceholder(true)
                self.shouldHideSortButton(false)
            case .loading:
                ProgressHUDWrapper.show()
            }
        }
    }

    func shouldHideSortButton(_ shouldHide: Bool) {
        let button = shouldHide ? nil : self.sortButton
        self.navigationItem.setRightBarButton(button, animated: true)
    }

    func configureView() {
        self.tableViewHelper.delegate = self

        self.cartView.tableViewHelper = self.tableViewHelper
        self.cartView.backgroundColor = .appWhite

        self.cartView.onTapPurchaseButton = { print("purchase button tapped") }
        self.cartView.onRefreshTable = { [weak self] in
            self?.viewModel.fetchOrder()
        }
    }
}

// MARK: - Actions
private extension CartViewController {
    @objc
    func didTapSortButton() {
        print(#function)
    }
}
