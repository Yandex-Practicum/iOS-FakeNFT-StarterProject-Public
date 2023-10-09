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
        tableView.register(
            StatisticsCell.self,
            forCellReuseIdentifier: StatisticsCell.identifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .nftWhite
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var viewModel: StatisticsViewModelProtocol
    
    init(viewModel: StatisticsViewModelProtocol = StatisticsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
// MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bind()
        viewModel.loadData()
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
            self?.viewModel.sortUsersByName()
        }
        
        let sortByRatingButton = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.viewModel.sortUsersByRating()
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
    
    private func bind() {
        viewModel.dataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
// MARK: - UITableViewDataSource
extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsCell.identifier,
            for: indexPath
        ) as? StatisticsCell else { return UITableViewCell() }

        let user = viewModel.users[indexPath.row]
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
