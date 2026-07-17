//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Сергей Петров on 16.07.2026.
//
import UIKit

final class CartViewController: UIViewController {

    // MARK: - Dependencies
    private let viewModel = CartViewModel()

    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let totalContainer = TotalContainerView()
    private let countLabel = UILabel()
    private let totalLabel = UILabel()
    private let payButton = UIButton(type: .system)

    // Заменяем обычный dimmingView на UIVisualEffectView для эффекта блюра
    private let blurOverlayView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular) // Темный блюр, чтобы белый текст читался
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
        setupTable()
        setupTotalSection()
        setupOverlay()
        applySnapshot(animated: false)
        updateTotal()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Корзина"

        view.addSubview(tableView)
        view.addSubview(totalContainer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        totalContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            totalContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            totalContainer.heightAnchor.constraint(equalToConstant: CartSizeConstants.totalSectionHeight),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalContainer.topAnchor)
        ])
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
        totalContainer.backgroundColor = UIColor(named: "yaLightGrey") ?? .secondarySystemBackground
        totalContainer.cornerRadius = CartSizeConstants.totalSectionRadius

        let leftStack = UIStackView(arrangedSubviews: [countLabel, totalLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 2
        leftStack.alignment = .leading

        countLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        countLabel.textColor = UIColor(named: "uniBackground") ?? .label

        totalLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        totalLabel.textColor = .systemGreen

        payButton.setTitle(NSLocalizedString("К оплате", comment: ""), for: .normal)
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        payButton.setTitleColor(UIColor(named: "yaWhite") ?? .white, for: .normal)
        payButton.backgroundColor = UIColor(named: "yaBlack") ?? .black
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
    }

    private func setupOverlay() {
        // Добавляем блюр-вью на весь экран
        view.addSubview(blurOverlayView)
        blurOverlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            blurOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Тап по размытому фону закрывает окно
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDeleteConfirmation))
        blurOverlayView.addGestureRecognizer(tapGesture)
    }

    private func applySnapshot(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CartItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animated)
        tableView.backgroundView = viewModel.items.isEmpty ? emptyView() : nil
    }

    private func updateTotal() {
        countLabel.text = "\(viewModel.items.count) NFT"
        totalLabel.text = String(format: "%.2f ETH", viewModel.totalPrice)
    }

    private func emptyView() -> UIView {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
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
}
