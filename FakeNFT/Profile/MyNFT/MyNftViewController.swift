//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 04.09.2023.
//

import UIKit

final class MyNftViewController: UIViewController {

    private lazy var myNftTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
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
