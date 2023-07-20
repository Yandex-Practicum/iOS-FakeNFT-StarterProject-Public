//
//  ProfileFavoritedNFTScreenController.swift
//  FakeNFT
//
//  Created by Илья Валито on 23.06.2023.
//

import UIKit

// MARK: - ProfileFavoritedNFTScreenController
final class ProfileFavoritedNFTScreenController: UIViewController {

    // MARK: - Properties and Initializers
    private var viewModel: ProfileFavoritedNFTScreenViewModel?
    private weak var delegate: ProfileUIUpdateDelegate?
    private let refreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "PULL_TO_REFRESH".localized)
        refreshControl.addTarget(nil, action: #selector(refreshCollection), for: .valueChanged)
        return refreshControl
    }()

    private let noNFTLabel = {
        let label = UICreator.makeLabel(text: "YOU_HAVE_NO_FAVORITED_NFT_YET".localized,
                                        font: UIFont.appFont(.bold, withSize: 17))
        label.isHidden = true
        return label
    }()
    private let activityIndicator = UICreator.makeActivityIndicator()
    private let nftCollectionView = {
        let collectionView = UICreator.makeCollectionView()
        collectionView.register(FavoritedNFTCell.self,
                                forCellWithReuseIdentifier: FavoritedNFTCell.reuseIdentifier)
        return collectionView
    }()

    convenience init(viewModel: ProfileFavoritedNFTScreenViewModel, delegate: ProfileUIUpdateDelegate) {
        self.init()
        self.viewModel = viewModel
        self.delegate = delegate
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FAVORITED_NFT".localized
        view.backgroundColor = .appWhite
        setupAutolayout()
        addSubviews()
        setupConstraints()
        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self
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
extension ProfileFavoritedNFTScreenController {

    @objc private func refreshCollection() {
        viewModel?.loadFavoritedNFTList()
    }

    private func setupAutolayout() {
        noNFTLabel.toAutolayout()
        activityIndicator.toAutolayout()
        nftCollectionView.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(noNFTLabel)
        view.addSubview(activityIndicator)
        nftCollectionView.refreshControl = refreshControl
        view.addSubview(nftCollectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$canShowUI.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                    self.nftCollectionView.reloadData()
                } else {
                    self.showOrHideUI()
                }
                self.checkIfNoNFT()
            }
        }
        viewModel.$canReloadCollection.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                self.nftCollectionView.reloadData()
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
            nftCollectionView.reloadData()
        } else {
            activityIndicator.startAnimating()
        }
        nftCollectionView.isHidden.toggle()
    }

    private func checkIfNoNFT() {
        guard let viewModel else { return }
        if viewModel.giveNumberOfFavoritedNFTCells() == 0 {
            nftCollectionView.isHidden.toggle()
            noNFTLabel.isHidden.toggle()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileFavoritedNFTScreenController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.giveNumberOfFavoritedNFTCells() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = viewModel?.configureCell(
            forCollectionView: collectionView,
            indexPath: indexPath
        ) as? FavoritedNFTCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        return cell
    }

}

// MARK: - UICollectionViewDelegate and
extension ProfileFavoritedNFTScreenController: UICollectionViewDelegate { }

// MARK: - UICollectionDelegateFlowLayout
extension ProfileFavoritedNFTScreenController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - 40
        let cellWidth =  availableWidth / CGFloat(2)
        return CGSize(width: cellWidth,
                      height: LocalConstants.collectionCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        LocalConstants.collectionMinimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        LocalConstants.collectionInteritemSpacing
    }
}

// MARK: - FavoritedNFTCellDelegate
extension ProfileFavoritedNFTScreenController: FavoritedNFTCellDelegate {

    func proceedLike(_ cell: FavoritedNFTCell) {
        guard let indexPath = nftCollectionView.indexPath(for: cell) else { return }
        viewModel?.proceedLike(forItem: indexPath.row)
    }
}

// MARK: - ErrorHandlerDelegate
extension ProfileFavoritedNFTScreenController: ErrorHandlerDelegate {

    func proceedError() {
        viewModel?.loadFavoritedNFTList()
    }
}

// MARK: - ProfileFavoritedNFTScreenController LocalConstants
private enum LocalConstants {

    static let collectionCellHeight: CGFloat = 80
    static let collectionMinimumLineSpacing: CGFloat = 20
    static let collectionInteritemSpacing: CGFloat = 7
}
