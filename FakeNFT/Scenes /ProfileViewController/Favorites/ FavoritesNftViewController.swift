//
//   FavoritesNftViewController.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 01.04.2025.
//

import UIKit

final class FavoritesNftViewController: UIViewController {
    
    var favoriteNfts: [MyNFT] = []
    var saveLikes: (() -> Void)?
    private let likesStorage = LikesStorageImpl.shared
    private lazy var nftFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "ETH"
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    override func loadView() {
        self.view = FavoritesNftView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupCollectionView()
        updateNFTView()
    }
    
    private func setupNavigationBar() {
        title = NSLocalizedString("Favorites", comment: "")
        navigationController?.navigationBar.tintColor = UIColor(named: "YBlackColor")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    private func setupCollectionView() {
        guard let favoritesView = view as? FavoritesNftView else { return }
        favoritesView.setCollectionViewDataSourceDelegate(dataSource: self, delegate: self)
    }
    
    @objc private func backButtonTapped() {
        saveLikes?()
        navigationController?.popViewController(animated: true)
    }
    
    private func updateNFTView() {
        guard let favoritesView = view as? FavoritesNftView else { return }
        favoritesView.updateNFTs(with: favoriteNfts)
    }
}

extension FavoritesNftViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteNfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NFTCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? NFTCollectionCell else {
            return UICollectionViewCell()
        }
        
        let nft = favoriteNfts[indexPath.item]
        let formattedPrice = nftFormatter.string(from: nft.price as NSNumber) ?? "\(nft.price) ETH"
        cell.configure(with: nft, formattedPrice: formattedPrice)
        
        cell.likeButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.likesStorage.removeLike(for: nft.id)
            self.favoriteNfts.removeAll { $0.id == nft.id }
            self.updateNFTView()
        }
        
        return cell
    }
}
