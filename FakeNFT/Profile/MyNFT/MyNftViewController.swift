//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 04.09.2023.
//

import UIKit

final class MyNftViewController: UIViewController {
    private let mockNft = MockNft.shared

    private lazy var myNftTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNftTableViewCell.self, forCellReuseIdentifier: MyNftTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Мои NFT"
        layouts()
        setupNavBar()
    }

    private func layouts() {
        view.addSubview(myNftTableView)
        NSLayoutConstraint.activate([
            myNftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            myNftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myNftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .label

        navigationController?.navigationBar.topItem?.title = ""
        let sortButton = UIBarButtonItem(image: UIImage(named: "Vector"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(sortNft))
        navigationItem.setRightBarButton(sortButton, animated: true)
    }

   @objc private func sortNft() {

    }
}

extension MyNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockNft.nft.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNftTableViewCell.identifier, for: indexPath) as? MyNftTableViewCell else { return UITableViewCell()}

        cell.configureTableView(image: mockNft.nft[indexPath.row].image,
                                rating: mockNft.nft[indexPath.row].rating,
                                name: mockNft.nft[indexPath.row].name,
                                value: mockNft.nft[indexPath.row].price)

        return cell
    }

}
