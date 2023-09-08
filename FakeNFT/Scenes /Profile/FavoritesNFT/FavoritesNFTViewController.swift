//
//  FavoritesNft.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 05.09.2023.
//

import UIKit

final class FavoritesNFTViewController: UIViewController {
    private let mockNft = MockNft.shared
    // MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(FavoritesNFTCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesNFTCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        label.text = "У Вас еще нет избранных NFT"
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Избранные NFT"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var visibleNFT: [MockNftModel] = []

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layouts()
        setupNavBar()
        visibleNFT = mockNft.nft
        checkPlaceholder()
    }
    // MARK: - Methods
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.topItem?.title = ""
    }
    private func checkPlaceholder() {
        if mockNft.nft.isEmpty {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
    }
    private func layouts() {
        [collectionView, placeHolderLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeHolderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension FavoritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockNft.nft.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoritesNFTCollectionViewCell.identifier,
            for: indexPath
        ) as? FavoritesNFTCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(name: mockNft.nft[indexPath.row].name,
                           price: mockNft.nft[indexPath.row].price,
                           rating: mockNft.nft[indexPath.row].rating,
                           image: mockNft.nft[indexPath.row].image
        )
        return cell
    }
}

extension FavoritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
