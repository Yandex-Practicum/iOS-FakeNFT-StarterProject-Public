//
//  StatisticUsersListView.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/14/25.
//
import UIKit

protocol StatisticUsersListViewDelegate: AnyObject {
    func clickSortButton()
}

final class StatisticUsersListView: UIView {
    lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "sort_button"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(didTapSortButton))
        button.tintColor = .segmentActive
        return button
    }()
    
    lazy var usersListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    weak var statisticUsersListViewDelegate: StatisticUsersListViewDelegate?
    
    func configure() {
        backgroundColor = .background
        
        usersListTableView.register(
            StatisticUsersListTableViewCell.self,
            forCellReuseIdentifier: StatisticUsersListTableViewCell.identifier
        )
        addSubview(usersListTableView)
        usersListTableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            usersListTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            usersListTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            usersListTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            usersListTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTapSortButton() {
        guard let statisticUsersListViewDelegate else { return }
        statisticUsersListViewDelegate.clickSortButton()
    }
}
