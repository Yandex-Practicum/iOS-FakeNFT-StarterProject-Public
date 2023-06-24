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

    private let noNFTLabel = {
        let label = UICreator.shared.makeLabel(text: "YOU_HAVE_NO_NFT_YET".localized,
                                               font: UIFont.appFont(.bold, withSize: 17))
        label.isHidden = true
        return label
    }()
    private let activityIndicator = UICreator.shared.makeActivityIndicator()
    private let nftTableView = {
        let tableView = UICreator.shared.makeTableView()
        tableView.register(NFTCell.self,
                           forCellReuseIdentifier: Constants.CollectionElementNames.profileNFTCell)

        return tableView
    }()

    convenience init(profile: ProfileModel?, delegate: ProfileUIUpdateDelegate) {
        self.init()
        self.viewModel = ProfileNFTScreenViewModel(profile: profile)
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

    private func setupAutolayout() {
        noNFTLabel.toAutolayout()
        activityIndicator.toAutolayout()
        nftTableView.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(noNFTLabel)
        view.addSubview(activityIndicator)
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
                self.showOrHideUI()
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
