//
//  ProfileNFTScreenController.swift
//  FakeNFT
//
//  Created by Илья Валито on 21.06.2023.
//

import UIKit

// MARK: - ProfileNFTScreenController
final class ProfileNFTScreenController: UIViewController {

    // MARK: - Properties and Initializers
    private var viewModel: ProfileNFTScreenViewModel?
    private weak var delegate: ProfileUIUpdateDelegate?
    private let refreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "PULL_TO_REFRESH".localized)
        refreshControl.addTarget(nil, action: #selector(refreshTable), for: .valueChanged)
        return refreshControl
    }()

    private let noNFTLabel = {
        let label = UICreator.makeLabel(text: "YOU_HAVE_NO_NFT_YET".localized,
                                        font: UIFont.appFont(.bold, withSize: 17))
        label.isHidden = true
        return label
    }()
    private let activityIndicator = UICreator.makeActivityIndicator()
    private let nftTableView = {
        let tableView = UICreator.makeTableView()
        tableView.register(NFTCell.self,
                           forCellReuseIdentifier: NFTCell.reuseIdentifier)
        return tableView
    }()

    convenience init(viewModel: ProfileNFTScreenViewModel, delegate: ProfileUIUpdateDelegate) {
        self.init()
        self.viewModel = viewModel
        self.delegate = delegate
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MY_NFT".localized
        view.backgroundColor = .appWhite
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.IconNames.sort),
                                                            style: .done,
                                                            target: nil,
                                                            action: #selector(sortTapped))
        (navigationController as? NavigationController)?.sortingButtonDelegate = self
        setupAutolayout()
        addSubviews()
        setupConstraints()
        nftTableView.dataSource = self
        nftTableView.delegate = self
        showOrHideUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateUI()
    }
}

// MARK: - Helpers
extension ProfileNFTScreenController {

    @objc private func refreshTable() {
        viewModel?.loadNFTList()
    }

    private func setupAutolayout() {
        noNFTLabel.toAutolayout()
        activityIndicator.toAutolayout()
        nftTableView.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(noNFTLabel)
        view.addSubview(activityIndicator)
        nftTableView.addSubview(refreshControl)
        view.addSubview(nftTableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$canShowUI.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                    self.nftTableView.reloadData()
                } else {
                    self.showOrHideUI()
                }
                self.checkIfNoNFT()
            }
        }
        viewModel.$canReloadTable.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                self.nftTableView.reloadData()
                self.checkIfNoNFT()
            }
        }
        viewModel.$shouldShowNetworkError.bind { [weak self] newValue in
            guard let self else { return }
            let errorHandler = ErrorHandler(delegate: self)
            self.present(errorHandler.giveAlert(withMessage: newValue), animated: true)
        }
    }

    private func showOrHideUI() {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            nftTableView.reloadData()
        } else {
            activityIndicator.startAnimating()
        }
        nftTableView.isHidden.toggle()
    }

    private func checkIfNoNFT() {
        guard let viewModel else { return }
        if viewModel.giveNumberOfNFTCells() == 0 {
            nftTableView.isHidden.toggle()
            noNFTLabel.isHidden.toggle()
        }
    }

    private func showSortingAlert() {
        let alertController = UIAlertController(title: "SORTING".localized,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let byPriceAction = UIAlertAction(title: "BY_PRICE".localized,
                                    style: .default
        ) { [weak self] _ in
            guard let self else { return }
            self.viewModel?.sortNFT(by: .byPrice)
        }
        let byRatingAction = UIAlertAction(title: "BY_RATING".localized,
                                    style: .default
        ) { [weak self] _ in
            guard let self else { return }
            self.viewModel?.sortNFT(by: .byRating)
        }
        let byNameAction = UIAlertAction(title: "BY_NAME".localized,
                                    style: .default
        ) { [weak self] _ in
            guard let self else { return }
            self.viewModel?.sortNFT(by: .byName)
        }
        let closeAction = UIAlertAction(title: "CLOSE".localized, style: .cancel)
        alertController.addAction(byPriceAction)
        alertController.addAction(byRatingAction)
        alertController.addAction(byNameAction)
        alertController.addAction(closeAction)
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSourceDelegate
extension ProfileNFTScreenController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.giveNumberOfNFTCells() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = viewModel?.configureCell(forTableView: tableView, indexPath: indexPath) as? NFTCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        return cell
    }
}

// MARK: - UITAbleViewDelegate
extension ProfileNFTScreenController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let removeButton = UIContextualAction(style: .destructive,
                                              title: "DELETE".localized) { [weak self] _, _, _ in
            guard let self else { return }
            let alertController = UIAlertController(title: "SURE_TO_DELETE".localized,
                                                    message: nil,
                                                    preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "DELETE".localized, style: .destructive) { [weak self] _ in
                guard let self else { return }
                self.viewModel?.deleteNFT(atRow: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            let cancelAction = UIAlertAction(title: "CANCEL".localized, style: .cancel) { _ in
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
        removeButton.backgroundColor = .appRed.withAlphaComponent(0)
        let config = UISwipeActionsConfiguration(actions: [removeButton])
        config.performsFirstActionWithFullSwipe = true
        return config
    }

    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        tableView.subviews.forEach { subview in
            if String(describing: type(of: subview)) == "_UITableViewCellSwipeContainerView" {
                if let actionView = subview.subviews.first,
                   String(describing: type(of: actionView)) == "UISwipeActionPullView" {
                    actionView.layer.cornerRadius = 12
                    actionView.layer.masksToBounds = true
                    actionView.backgroundColor = .appRed
                    (actionView.subviews.first as? UIButton)?.titleLabel?.font = UIFont.appFont(.bold, withSize: 17)
                }
            }
        }
    }
}

// MARK: - NFTCellDelegate
extension ProfileNFTScreenController: NFTCellDelegate {

    func proceedLike(_ cell: NFTCell) {
        guard let indexPath = nftTableView.indexPath(for: cell) else { return }
        viewModel?.proceedLike(forRow: indexPath.row)
    }
}

// MARK: - NavigationControllerSortingButtonDelegate
extension ProfileNFTScreenController: NavigationControllerSortingButtonDelgate {

    @objc internal func sortTapped() {
        showSortingAlert()
    }
}

// MARK: - ErrorHandlerDelegate
extension ProfileNFTScreenController: ErrorHandlerDelegate {

    func proceedError() {
        viewModel?.loadNFTList()
    }
}
