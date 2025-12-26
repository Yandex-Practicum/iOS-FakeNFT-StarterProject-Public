//
//  StatisticUsersListViewController.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/14/25.
//
import UIKit

protocol StatisticUsersListVCDelegate: AnyObject {
    func didTapCell(with user: UsersListModel)
}

final class StatisticUsersListViewController: UIViewController {
    // MARK: - Public Properties
    weak var statisticUsersListVCDelegate: StatisticUsersListVCDelegate?
    // MARK: - Private Properties
    private var sort: SortCases? {
        didSet {
            sortStorage.selectedSort = sort
        }
    }
    private let statisticUsersListView = StatisticUsersListView()
    private let sortStorage = SortStorage.shared
    private let usersListService = UsersListService.shared
    private var usersListServiceObserver: NSObjectProtocol?
    private var users: [UsersListModel] = []
    // MARK: - Lifecycle
    override func loadView() {
        self.view = statisticUsersListView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticUsersListView.configure()
        showActivityIndicator()
        setupNavigationBar()
        setupTableView()
        setupObserver()
        statisticUsersListView.statisticUsersListViewDelegate = self
        usersListService.fetchUsersNextPage()
    }
    // MARK: - Private Methods
    private func setupTableView() {
        statisticUsersListView.usersListTableView.dataSource = self
        statisticUsersListView.usersListTableView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .background
        navigationItem.rightBarButtonItem = statisticUsersListView.sortButton
    }
    
    private func setupObserver() {
        usersListServiceObserver = NotificationCenter.default
            .addObserver(forName: UsersListService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
                self.hideActivityIndicator()
            }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = users.count
        let newCount = usersListService.users.count
        users = usersListService.users
        if oldCount != newCount {
            statisticUsersListView.usersListTableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                statisticUsersListView.usersListTableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func showActivityIndicator() {
        statisticUsersListView.activityIndicator.startAnimating()
        statisticUsersListView.usersListTableView.isHidden = true
        statisticUsersListView.activityIndicator.isHidden = false
    }

    private func hideActivityIndicator() {
        statisticUsersListView.activityIndicator.stopAnimating()
        statisticUsersListView.usersListTableView.isHidden = false
        statisticUsersListView.activityIndicator.isHidden = true
    }
}
    // MARK: - UITableViewDelegate
extension StatisticUsersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userCardVC = UserCardViewController(statisticUsersListViewController: self)
        let userCardVCNavController = UINavigationController(rootViewController: userCardVC)
        userCardVCNavController.setNavigationBarHidden(false, animated: false)
        userCardVCNavController.modalPresentationStyle = .fullScreen
        statisticUsersListVCDelegate?.didTapCell(with: users[indexPath.row])
        present(userCardVCNavController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
}
    // MARK: - UITableViewDataSource
extension StatisticUsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticUsersListTableViewCell.identifier, for: indexPath) as? StatisticUsersListTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let user = users[indexPath.row]
        cell.configure(with: user, place: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == users.count {
            usersListService.fetchUsersNextPage()
        }
    }
}
    // MARK: - StatisticUsersListViewDelegate
extension StatisticUsersListViewController: StatisticUsersListViewDelegate {
    func clickSortButton() {
        let nameAction = SortAlertPresenter.createAction(title: SortCases.name.title, style: .default) { [weak self] _ in
            guard let self else { return }
            self.sort = .name
            self.users = []
            statisticUsersListView.usersListTableView.reloadData()
            usersListService.deleteUsersList()
            usersListService.fetchUsersNextPage()
        }
        let rateAction = SortAlertPresenter.createAction(title: SortCases.rating.title, style: .default) { [weak self] _ in
            guard let self else { return }
            self.sort = .rating
            self.users = []
            statisticUsersListView.usersListTableView.reloadData()
            usersListService.deleteUsersList()
            usersListService.fetchUsersNextPage()
        }
        let cancelAction = SortAlertPresenter.createAction(title: "Закрыть", style: .cancel)
        
        SortAlertPresenter.present(title: nil, message: "Сортировка", actions: nameAction, rateAction, cancelAction, from: self)
    }
}
