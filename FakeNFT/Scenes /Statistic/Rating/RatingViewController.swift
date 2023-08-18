//
//  RatingViewController.swift
//  FakeNFT
//
//  Created by macOS on 20.06.2023.
//

import UIKit
import ProgressHUD

final class RatingViewController: UIViewController {
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sortIcon"), for: .normal)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var ratingTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserRatingCell.self)
        tableView.separatorStyle = .none
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshRating), for: .valueChanged)
        return tableView
    }()
    
    private let viewModel = RatingViewModel()
    private var sortAlert: UIAlertController? = nil
    
    private var userList: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSortAlert()

        addViews()
        setUpConstraints()
        
        bind()
        viewModel.getUserList()
    }
    
    private func bind() {
        viewModel.$userList.bind { [weak self] userList in
            self?.userList = userList
            self?.ratingTableView.reloadData()
        }
        viewModel.$errorMessage.bind { [weak self] errorMessage in
            self?.presentErrorDialog(message: errorMessage)
        }
        viewModel.$isLoading.bind { isLoading in
            if isLoading {
                ProgressHUD.show()
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
    
    @objc private func sortButtonTapped() {
        guard let sortAlert else { return }
        present(sortAlert, animated: true)
    }
    
    @objc private func refreshRating() {
        ratingTableView.refreshControl?.endRefreshing()
        viewModel.getUserList()
    }
    
    private func addViews() {
        view.addSubview(sortButton)
        view.addSubview(ratingTableView)
    }
    
    private func setUpConstraints() {
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        ratingTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            
            ratingTableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            ratingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            ratingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ratingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func initSortAlert() {
        sortAlert = SortAlertBuilder.buildSortAlert(onNameSort: { [weak self] in
            self?.viewModel.sortByName()
        }, onRatingSort: { [weak self] in
            self?.viewModel.sortByRating()
        })
    }
    
}

extension RatingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserRatingCell = tableView.dequeueReusableCell()
        
        let index = indexPath.row
        cell.configure(index: index, user: userList[index])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = userList[indexPath.row].id
        
        if let userId = Int(userId) {
            navigateToRatingProfile(userId: Int(userId))
        }
    }
    
    private func navigateToRatingProfile(userId: Int) {
        let vc = RatingProfileViewController(userId: userId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
