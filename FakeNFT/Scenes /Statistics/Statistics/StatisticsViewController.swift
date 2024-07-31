//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit
import SnapKit

protocol StatisticsViewProtocol: AnyObject {
    func updateUsers(with users: [NFTUser])
}

final class StatisticsViewController: UIViewController {
    
    var presenter: StatisticsPresenterProtocol?
    let cellReuseIdentifier = "tableViewCellIdentifier"
    
    private var customNavBar = StatisticsCustomNavBar()
    private var ratingTableView = UITableView()
    
    private var users : [NFTUser] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        initializeUI()
        users = presenter?.getUserList() ?? []
    }
    
    private func initializeUI() {
        setupUI()
        prepareRatingTable()
        prepareNavBar()
        activatingConstraints()
    }
    
    private func setupUI() {
        for subView in [customNavBar, ratingTableView ] {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activatingConstraints() {
        customNavBar.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(42)
        }
        
        ratingTableView.snp.makeConstraints({ make in
            make.top.equalTo(customNavBar.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        })
    }
    private func prepareNavBar(){
        customNavBar.isBackButtonInvisible(it_s: true)
        customNavBar.isSortButtonInvisible(it_s: false)
        customNavBar.isTitleInvisible(it_s: true)
        customNavBar.sortButton.addTarget(self, action: #selector(showSortActionSheet), for: .touchUpInside)
    }
    
    private func prepareRatingTable() {
        ratingTableView.layer.cornerRadius = 16
        ratingTableView.clipsToBounds = true
        ratingTableView.separatorStyle = .none
        ratingTableView.dataSource = self
        ratingTableView.delegate = self
        ratingTableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    //MARK: - OBJC functions
    
    @objc private func showSortActionSheet() {
        let actionSheet = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let byNameAction = UIAlertAction(title: "По имени", style: .default) { _ in
            self.sortUsersByName()
        }
        
        let byRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.sortUsersByRating()
        }
        
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        actionSheet.addAction(byNameAction)
        actionSheet.addAction(byRatingAction)
        actionSheet.addAction(closeAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func sortUsersByName() {
        users.sort { $0.name < $1.name }
        ratingTableView.reloadData()
    }
    
    private func sortUsersByRating() {
        users.sort { $0.rating > $1.rating }
        ratingTableView.reloadData()
    }
    
}

// MARK: - StatisticsViewProtocol
extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                       for: indexPath) as? StatisticsTableViewCell else {return StatisticsTableViewCell()}
        cell.setUserName(with: users[indexPath.row].name)
        cell.setUserImage(with: users[indexPath.row].avatar)
        cell.setUserCollectionAmount(with: users[indexPath.row].nfts.count.description)
        cell.setCellIndex(with: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadUserCard(with: users[indexPath.row])
    }
}

extension StatisticsViewController {
    func loadUserCard(with selectedUser : NFTUser){
        if let userCardViewController = presenter?.loadUserCard(with: selectedUser) {
            present(userCardViewController, animated: true, completion: nil)
        }
    }
}

extension StatisticsViewController: StatisticsViewProtocol {
    func updateUsers(with users: [NFTUser]) {
        self.users = users
        ratingTableView.reloadData()
    }
}
