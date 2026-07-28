//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Сергей Петров on 16.07.2026.
//
import UIKit
import ProgressHUD
import os

final class CartViewController: UIViewController {

    // MARK: - Dependencies
    private let viewModel = CartViewModel()
    
    private var paymentCoordinator: PaymentCoordinator?
    
    private let sortStorage = CartSortStorage.shared

    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let totalContainer = TotalContainerView()
    private let countLabel = UILabel()
    private let totalLabel = UILabel()
    private let payButton = UIButton(type: .system)

    // MARK: - Constraints для анимации появления/исчезновения
    private var tableViewBottomToContainerConstraint: NSLayoutConstraint?
    private var tableViewBottomToSafeAreaConstraint: NSLayoutConstraint?

    private let blurOverlayView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: effect)
        view.alpha = 0.0
        view.isHidden = true
        return view
    }()
    
    private var confirmationView: DeleteConfirmationView?

    // MARK: - Diffable
    private enum Section { case main }
    private var dataSource: UITableViewDiffableDataSource<Section, CartItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupTable()
        setupTotalSection()
        setupOverlay()
        
        updateTotal()
        updateEmptyState()
        
        observeLoadingState()
        observeItemsState()
        
        applySort(sortStorage.selectedSort)
        
        if viewModel.isLoading {
            os_log(.info, log: .default, "⏳ [UI] Показываем HUD из viewDidLoad")
            ProgressHUD.show("Загрузка корзины...")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ProgressHUD.dismiss()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Корзина"

        view.addSubview(tableView)
        view.addSubview(totalContainer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        totalContainer.translatesAutoresizingMaskIntoConstraints = false

        let bottomToContainer = tableView.bottomAnchor.constraint(equalTo: totalContainer.topAnchor)
        let bottomToSafeArea = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        tableViewBottomToContainerConstraint = bottomToContainer
        tableViewBottomToSafeAreaConstraint = bottomToSafeArea
        

        NSLayoutConstraint.activate([
            totalContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            totalContainer.heightAnchor.constraint(equalToConstant: CartSizeConstants.totalSectionHeight),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        bottomToContainer.isActive = true
    }
    
    private func setupNavigationBar() {
        let sortImage = UIImage(resource: .sort)
        let sortButton = UIBarButtonItem(
            image: sortImage,
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        sortButton.tintColor = UIColor(resource: .yaBlack)
        
        navigationItem.rightBarButtonItem = sortButton
    }

    private func setupTable() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.reuseId)

        dataSource = UITableViewDiffableDataSource<Section, CartItem>(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.reuseId, for: indexPath) as? CartItemCell else {
                return UITableViewCell()
            }
            cell.configure(with: item)
            cell.onDelete = { [weak self] in
                self?.presentDeleteConfirmation(for: item)
            }
            return cell
        }
    }

    private func setupTotalSection() {
        totalContainer.backgroundColor = UIColor(resource: .yaLightGrey)
        totalContainer.cornerRadius = CartSizeConstants.totalSectionRadius

        let leftStack = UIStackView(arrangedSubviews: [countLabel, totalLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 2
        leftStack.alignment = .leading

        countLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        countLabel.textColor = UIColor(resource: .uniBackground)

        totalLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        totalLabel.textColor = .systemGreen

        payButton.setTitle(NSLocalizedString("К оплате", comment: ""), for: .normal)
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        payButton.setTitleColor(UIColor(resource: .yaWhite), for: .normal)
        payButton.backgroundColor = UIColor(resource: .yaBlack)
        payButton.layer.cornerRadius = CartSizeConstants.buttonRadius
        payButton.clipsToBounds = true

        totalContainer.addSubview(leftStack)
        totalContainer.addSubview(payButton)
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leftStack.leadingAnchor.constraint(equalTo: totalContainer.leadingAnchor, constant: 16),
            leftStack.centerYAnchor.constraint(equalTo: totalContainer.centerYAnchor),

            payButton.trailingAnchor.constraint(equalTo: totalContainer.trailingAnchor, constant: -16),
            payButton.centerYAnchor.constraint(equalTo: totalContainer.centerYAnchor),
            payButton.widthAnchor.constraint(equalToConstant: CartSizeConstants.paymentButtonWidth),
            payButton.heightAnchor.constraint(equalToConstant: CartSizeConstants.paymentButtonHeight)
        ])
        
        payButton.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
    }

    private func setupOverlay() {
        view.addSubview(blurOverlayView)
        blurOverlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            blurOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDeleteConfirmation))
        blurOverlayView.addGestureRecognizer(tapGesture)
    }

    private func applySnapshot(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CartItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animated)
        tableView.backgroundView = viewModel.items.isEmpty ? emptyView() : nil
        updateEmptyState()
    }

    private func updateTotal() {
        countLabel.text = "\(viewModel.items.count) NFT"
        totalLabel.text = String(format: "%.2f ETH", viewModel.totalPrice)
    }

    private func emptyView() -> UIView {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.textAlignment = .center
        label.textColor = UIColor(resource: .yaBlack)
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }
    
    // MARK: - Observation
      private func observeLoadingState() {
          withObservationTracking {
              _ = viewModel.isLoading
          } onChange: { [weak self] in
              guard let self else { return }
              
              Task { @MainActor in
                  if !self.viewModel.isLoading {
                      os_log(.info, log: .default, "✅ [UI] Вызываем ProgressHUD.dismiss()")
                      ProgressHUD.dismiss()
                  }
                  
                  self.observeLoadingState()
              }
          }
      }

      private func observeItemsState() {
          withObservationTracking {
              _ = viewModel.items
          } onChange: { [weak self] in
              guard let self else { return }
              Task { @MainActor in
                  os_log(.info, log: .default, "📱 [UI] Обновляем таблицу. Товаров: %{public}d", self.viewModel.items.count)
                  self.applySnapshot(animated: true)
                  self.updateTotal()
                  self.updateEmptyState()
                  self.observeItemsState()
              }
          }
      }

    // MARK: - Empty State Logic
    private func updateEmptyState() {
        let isEmpty = viewModel.items.isEmpty
        
        UIView.animate(withDuration: 0.3, animations: {
            self.totalContainer.isHidden = isEmpty
            self.tableViewBottomToContainerConstraint?.isActive = !isEmpty
            self.tableViewBottomToSafeAreaConstraint?.isActive = isEmpty
            
            self.view.layoutIfNeeded()
        })
    }

    // MARK: - Delete Confirmation
    private func presentDeleteConfirmation(for item: CartItem) {
        tabBarController?.tabBar.isHidden = true

        let confirmation = DeleteConfirmationView(item: item)
        confirmation.onConfirm = { [weak self] in
            guard let self else { return }
            self.hideDeleteConfirmation(animated: true) {
                self.viewModel.removeItem(item)
                self.applySnapshot()
                self.updateTotal()
            }
        }
        confirmation.onCancel = { [weak self] in
            self?.hideDeleteConfirmation(animated: true, completion: nil)
        }

        confirmation.alpha = 0
        view.addSubview(confirmation)
        confirmation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmation.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            confirmation.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9)
        ])

        confirmationView = confirmation
        blurOverlayView.isHidden = false

        UIView.animate(withDuration: 0.25) {
            self.blurOverlayView.alpha = 1.0
            confirmation.alpha = 1.0
        }
    }

    @objc private func dismissDeleteConfirmation() {
        hideDeleteConfirmation(animated: true, completion: nil)
    }

    private func hideDeleteConfirmation(animated: Bool, completion: (() -> Void)?) {
        let animations = {
            self.blurOverlayView.alpha = 0.0
            self.confirmationView?.alpha = 0.0
        }
        let completionBlock: (Bool) -> Void = { _ in
            self.blurOverlayView.isHidden = true
            self.confirmationView?.removeFromSuperview()
            self.confirmationView = nil
            self.tabBarController?.tabBar.isHidden = false
            completion?()
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: animations, completion: completionBlock)
        } else {
            animations()
            completionBlock(true)
        }
    }
    
    // MARK: - Actions
    @objc private func paymentButtonTapped() {
        guard let navigationController = self.navigationController else {
            os_log(.error, log: .default, "CartViewController is not inside a UINavigationController")
            return
        }
        
        paymentCoordinator = PaymentCoordinator(
            navigationController: navigationController,
            cartItems: viewModel.items
        )
        
        paymentCoordinator?.start()
    }

    @objc private func sortButtonTapped() {
        let alert = UIAlertController(
            title: NSLocalizedString("Сортировка", comment: "Заголовок сортировки"),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for sortType in CartSortType.allCases {
            let action = UIAlertAction(title: sortType.localizedTitle, style: .default) { [weak self] _ in
                self?.applySort(sortType)
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Закрыть", comment: "Закрыть"),
            style: .cancel
        )
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alert, animated: true)
    }
    
    private func applySort(_ sortType: CartSortType) {
        sortStorage.selectedSort = sortType
        
        viewModel.sortItems(by: sortType)
        
        applySnapshot(animated: true)
    }
}
