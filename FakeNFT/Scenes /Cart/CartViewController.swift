//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Svetlana Varenova on 25.11.2025.
//

import UIKit

final class CartViewController: UIViewController, CartTableViewCellDelegate {
    
    private let viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView = UITableView()
    private let bottomView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTable()
        setupBottom()
        setupBindings()
        
    }
    
    // MARK: - Setup bindings
    private func setupBindings() {
        viewModel.onItemsUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Setup Table
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130)
        ])
    }
    
    // MARK: - Setup Bottom
    private func setupBottom() {
        bottomView.backgroundColor = .secondarySystemBackground
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 130),
        ])
    }
}

// MARK: - TableView
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.item(at: indexPath.row)
        cell.configure(with: item)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - CartTableViewCellDelegate
    func cartCell(_ cell: CartTableViewCell, didChangeRating rating: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.updateRating(at: indexPath.row, rating: rating)
    }
    
    func cartCellDidTapDelete(_ cell: CartTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.removeItem(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

#Preview {
    CartViewController(viewModel: CartViewModel())
}
