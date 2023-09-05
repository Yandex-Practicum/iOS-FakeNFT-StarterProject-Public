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
          showAlert()
    }

    private func showAlert() {
        let alertController = UIAlertController(title: nil,
                                      message: "Сортировка",
                                      preferredStyle: .actionSheet)

        let actionFirst = UIAlertAction(title: "По цене", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            print("price sorted")
        }
        alertController.addAction(actionFirst)

        let actionSecond = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            print("rating sorted")
        }
        alertController.addAction(actionSecond)

        let actionThird = UIAlertAction(title: "По имени", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            print("by name sorted")
        }
        alertController.addAction(actionThird)

        let actionCancel = UIAlertAction(title: "Закрыть", style: .cancel) { [weak self] (_) in
            guard let self = self else { return }
            print("cancel")
        }
        alertController.addAction(actionCancel)
        navigationController?.present(alertController, animated: true)
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
