//
//  RatingViewController.swift
//  FakeNFT
//

import UIKit

final class StatisticsViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .nftWhite
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var users: [UserCard] = [
        UserCard(rating: 3, image: UIImage(systemName: "person.crop.circle.fill"), name: "Sara", userCollection: 112),
        UserCard(rating: 2, image: UIImage(systemName: "person.crop.circle.fill"), name: "Will", userCollection: 10),
        UserCard(rating: 1, image: UIImage(systemName: "person.crop.circle.fill"), name: "Lion", userCollection: 32),
        UserCard(rating: 4, image: UIImage(systemName: "person.crop.circle.fill"), name: "Alex", userCollection: 54)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
// MARK: - Action
    @objc
    private func sortingUsers() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        let sortByNameButton = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.users.sort { $0.name < $1.name }
            self?.tableView.reloadData()
        }
        
        let sortByRatingButton = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.users.sort { $0.userCollection > $1.userCollection }
            self?.tableView.reloadData()
        }
        
        let closeButton = UIAlertAction(title: "Закрыть", style: .default)
        alert.addAction(sortByNameButton)
        alert.addAction(sortByRatingButton)
        alert.addAction(closeButton)
        present(alert, animated: true)
    }
// MARK: - Setup
    private func setupUI() {
        view.addSubview(tableView)
        view.backgroundColor = .nftWhite
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let filterButton = UIBarButtonItem(
            image: UIImage(named: "SortIcon"),
            style: .plain,
            target: self,
            action: #selector(sortingUsers)
        )
        
        filterButton.tintColor = UIColor.nftBlack
        navigationItem.rightBarButtonItem = filterButton
    }
}
// MARK: - UITableViewDataSource
extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsCell.identifier,
            for: indexPath
        ) as? StatisticsCell else { return UITableViewCell() }

        let user = users[indexPath.row]
        cell.configure(model: user)
        return cell
    }
}
// MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userCard = UserCardViewController()
        navigationController?.pushViewController(userCard, animated: true)
    }
}
