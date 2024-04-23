//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Chingiz on 19.04.2024.
//

import UIKit

final class CartViewController: UIViewController {

    private let sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "sortButton.png")
        button.setImage(image, for: .normal)
        return button
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.masksToBounds = true
        table.separatorStyle = .none
        table.register(CustomCellViewCart.self, forCellReuseIdentifier: CustomCellViewCart.reuseIdentifier)
        return table
    }()

    private let priceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: "Light grey [day]")
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        return view
    }()

    private let payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Cart.payBttn", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(named: "blackDayNight")
        button.layer.cornerRadius = 16
        return button
    }()

    private let valueNft: UILabel = {
        let label = UILabel()
        label.text = "3 NFT"
        label.textColor = UIColor(named: "blackDayNight")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    private let priceNfts: UILabel = {
        let label = UILabel()
        label.text = "5,34 ETH"
        label.textColor = UIColor(named: "greenUnivesal")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    private let priceStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 2
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureConstraits()
    }

    private func configureView() {
        [tableView,
        priceView].forEach {
            view.addSubview($0)
        }
        [valueNft,
         priceNfts].forEach {
            priceStack.addArrangedSubview($0)
        }
        [priceStack,
         payButton].forEach {
            priceView.addSubview($0)
        }
        tableView.dataSource = self
        tableView.delegate = self
        let segmentBarItem = UIBarButtonItem(customView: sortButton)
        navigationItem.rightBarButtonItem = segmentBarItem    }

    private func configureConstraits() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: priceView.topAnchor),

            priceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            priceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            priceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            priceStack.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 16),
            priceStack.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 16),
            priceStack.bottomAnchor.constraint(equalTo: priceView.bottomAnchor, constant: -16),

            payButton.leadingAnchor.constraint(equalTo: priceStack.trailingAnchor, constant: 24),
            payButton.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 16),
            payButton.bottomAnchor.constraint(equalTo: payButton.bottomAnchor, constant: -16),
            payButton.trailingAnchor.constraint(equalTo: priceView.trailingAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44)

        ])
    }

}

extension CartViewController: UITableViewDelegate {

}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCellViewCart.reuseIdentifier, for: indexPath) as? CustomCellViewCart else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

extension CartViewController: CustomCellViewCartDelegate {
    func cellDidTapDeleteCart() {
        print("YF:FNF")
        let newCategoryViewController = CartDeleteConfirmView()
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true)
    }
}
