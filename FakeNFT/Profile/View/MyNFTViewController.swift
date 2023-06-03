//
//  MyNFTViewController.swift
//  FakeNFT
//

import UIKit
import ProgressHUD
import Kingfisher

final class MyNFTViewController: UIViewController {

    var viewModel: NFTsViewModelProtocol?

    var myNFTs: [Int] = []

    private lazy var nftTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(MyNFTTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupConstraints()
        setupController()
        bind()
        viewModel?.get(myNFTs)
        viewModel?.getAuthors()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KingfisherManager.shared.downloader.cancelAll()
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.nftViewModelsObservable.bind { [weak self] _ in
            self?.nftTableView.performBatchUpdates {
                self?.nftTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
        viewModel.isNFTsDownloadingNowObservable.bind { isNFTsDownloadingNow in
            isNFTsDownloadingNow ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
        }
        viewModel.authorsObservable.bind { [weak self] _ in
            self?.nftTableView.performBatchUpdates {
                self?.nftTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }

    private func setupController() {
        view.backgroundColor = .viewBackgroundColor
        title = String(NSLocalizedString("myNFTs", comment: "My NFT screen title").dropLast(5))
    }

    private func setupNavigationController() {
        let rightButton = UIBarButtonItem(image: UIImage(named: "SortButton"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(sortMyNFTAction))
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc private func sortMyNFTAction() {

    }

    private func setupConstraints() {
        view.addSubview(nftTableView)
        NSLayoutConstraint.activate([
            nftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate

extension MyNFTViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource

extension MyNFTViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.nftViewModels.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return  UITableViewCell() }
        let cell: MyNFTTableViewCell = tableView.dequeueReusableCell()
        cell.configCell(from: viewModel.nftViewModels[indexPath.row])
        let author = viewModel.authorsObservable.wrappedValue.first { $0.nftID == cell.id }?.name
        cell.set(author: author ?? "")
        return cell
    }
}
