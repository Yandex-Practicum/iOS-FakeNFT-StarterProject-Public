//
//  FavoritesNFTViewController.swift
//  FakeNFT
//

import UIKit
import Kingfisher
import ProgressHUD

final class FavoritesNFTViewController: UIViewController {

    private let nftsViewModel: NFTsViewModelProtocol

    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.favoritesNFTStubLabelText
        label.font = UIFont.systemFont(ofSize: 17, weight:  .bold)
        label.textColor = .textColorBlack
        label.isHidden = nftsViewModel.stubLabelIsHidden
        return label
    }()

    private lazy var favoritesNFTCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoritesNFTCollectionViewCell.self)
        return collectionView
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
        setupController()
        setupConstraints()
        bind()
        nftsViewModel.nftViewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KingfisherManager.shared.downloader.cancelAll()
    }

    private func bind() {
        nftsViewModel.nftViewModelsObservable.bind { [weak self] _ in
            guard let self = self else { return }
            self.favoritesNFTCollectionView.performBatchUpdates({
                self.favoritesNFTCollectionView.reloadSections(IndexSet(integer: 0))
                self.stubLabel.isHidden = self.nftsViewModel.stubLabelIsHidden
            })
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
        view.backgroundColor = .white
        title = nftsViewModel.favoritesNFTsTitle
    }

    private func setupConstraints() {
        [favoritesNFTCollectionView, stubLabel].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            favoritesNFTCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            favoritesNFTCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoritesNFTCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            favoritesNFTCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesNFTViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 40) / 2, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesNFTViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nftsViewModel.nftViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoritesNFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.delegate = self
        cell.configCell(from: nftsViewModel.nftViewModels[indexPath.row])
        return cell
    }
}

// MARK: - FavoritesNFTCellDelegate

extension FavoritesNFTViewController: FavoritesNFTCellDelegate {

    func didTapLike(_ cell: FavoritesNFTCollectionViewCell) {
        guard let indexPath = favoritesNFTCollectionView.indexPath(for: cell) else { return }
        UIBlockingProgressHUD.show()
        nftsViewModel.didTapLike(nft: indexPath.item) {
            cell.changeLikeButtonImage()
            UIBlockingProgressHUD.dismiss()
        }
    }
}
