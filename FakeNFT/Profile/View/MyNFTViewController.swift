//
//  MyNFTViewController.swift
//  FakeNFT
//

import UIKit
import ProgressHUD
import Kingfisher

final class MyNFTViewController: UIViewController {

    private let nftsViewModel: NFTsViewModelProtocol

    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.myNFTStubLabelText
        label.font = UIFont.systemFont(ofSize: 17, weight:  .bold)
        label.textColor = .textColorBlack
        label.isHidden = nftsViewModel.stubLabelIsHidden
        return label
    }()

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

    init(nftsViewModel: NFTsViewModelProtocol) {
        self.nftsViewModel = nftsViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupConstraints()
        setupController()
        bind()
        nftsViewModel.nftViewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KingfisherManager.shared.downloader.cancelAll()
    }

    private func bind() {
        nftsViewModel.nftViewModelsObservable.bind { [weak self] _ in
            self?.nftTableView.performBatchUpdates {
                self?.nftTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
        nftsViewModel.isNFTsDownloadingNowObservable.bind { isNFTsDownloadingNow in
            isNFTsDownloadingNow ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
        }
        nftsViewModel.nftsReceivingErrorObservable.bind { [weak self] error in
            self?.showAlertMessage(with: error, tryAgainAction: {
                self?.nftsViewModel.nftViewDidLoad()
            }, cancelAction: {
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }

    private func setupController() {
        view.backgroundColor = .viewBackgroundColor
        title = nftsViewModel.myNFTsTitle
    }

    private func setupNavigationController() {
        let rightButton = UIBarButtonItem(image: UIImage(named: "SortButton"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(sortMyNFTAction))
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc private func sortMyNFTAction() {
        let sortAlert = UIAlertController(title: nil, message: Constants.sortingAlertTitle, preferredStyle: .actionSheet)
        let sortByPriceAction = UIAlertAction(title: Constants.sortByPriceString, style: .default) { [weak self] _ in
            self?.nftsViewModel.myNFTSorted(by: .price)
        }
        let sortByRatingAction = UIAlertAction(title: Constants.sortByRatingString, style: .default) { [weak self] _ in
            self?.nftsViewModel.myNFTSorted(by: .rating)
        }
        let sortByNameAction = UIAlertAction(title: Constants.sortByNameString, style: .default) { [weak self] _ in
            self?.nftsViewModel.myNFTSorted(by: .name)
        }
        let closeAction = UIAlertAction(title: Constants.closeButtonTitle, style: .cancel)
        [sortByPriceAction, sortByRatingAction, sortByNameAction, closeAction].forEach { sortAlert.addAction($0) }
        present(sortAlert, animated: true)
    }

    private func setupConstraints() {
        [nftTableView, stubLabel].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            nftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate

extension MyNFTViewController: UITableViewDelegate {   }

// MARK: - UITableViewDataSource

extension MyNFTViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftsViewModel.nftViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyNFTTableViewCell = tableView.dequeueReusableCell()
        cell.configCell(from: nftsViewModel.nftViewModels[indexPath.row])
        return cell
    }
}
