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
    // MARK: - UI Elements
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
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .segmentActive
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    // MARK: - Public Properties
    weak var statisticUsersListViewDelegate: StatisticUsersListViewDelegate?
    // MARK: - Selectors
    @objc private func didTapSortButton() {
        guard let statisticUsersListViewDelegate else { return }
        statisticUsersListViewDelegate.clickSortButton()
    }
    // MARK: - Public Methods
    func configure() {
        backgroundColor = .background
        
        usersListTableView.register(
            StatisticUsersListTableViewCell.self,
            forCellReuseIdentifier: StatisticUsersListTableViewCell.identifier
        )
        addSubview(usersListTableView)
        addSubview(activityIndicator)
        
        usersListTableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            usersListTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            usersListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            usersListTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            usersListTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
