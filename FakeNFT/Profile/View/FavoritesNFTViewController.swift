//
//  FavoritesNFTViewController.swift
//  FakeNFT
//

import UIKit
import Kingfisher
import ProgressHUD

final class FavoritesNFTViewController: UIViewController {

    var viewModel: NFTsViewModelProtocol?
    var favoritesNFTs: [Int] = []

    private lazy var favoritesNFTCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoritesNFTCollectionViewCell.self)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupConstraints()
        bind()
        viewModel?.get(favoritesNFTs)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KingfisherManager.shared.downloader.cancelAll()
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.nftViewModelsObservable.bind { [weak self] _ in
            self?.favoritesNFTCollectionView.performBatchUpdates({
                self?.favoritesNFTCollectionView.reloadData()
            })
        }
        viewModel.isNFTsDownloadingNowObservable.bind { isNFTsDownloadingNow in
            isNFTsDownloadingNow ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
        }
    }

    private func setupController() {
        title = NSLocalizedString("favoritesNFT", comment: "Favorites NFT screen title")
        view.backgroundColor = .white
    }

    private func setupConstraints() {
        view.addSubview(favoritesNFTCollectionView)
        NSLayoutConstraint.activate([
            favoritesNFTCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            favoritesNFTCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoritesNFTCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            favoritesNFTCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
        viewModel?.nftViewModels.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return  UICollectionViewCell() }
        let cell: FavoritesNFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configCell(from: viewModel.nftViewModels[indexPath.row])
        return cell
    }
}
