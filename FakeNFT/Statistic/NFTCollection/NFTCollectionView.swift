//
//  NFTCollectionView.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/26/25.
//
import UIKit

final class NFTCollectionView: UIView {
    // MARK: - UI Elements
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .background
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .segmentActive
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    lazy var emptyCollectionTitle: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Нет NFT в коллекции"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Public Methods
    func configure() {
        backgroundColor = .background
        addSubview(collectionView)
        addSubview(activityIndicator)
        addSubview(emptyCollectionTitle)
        
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTCollectionViewCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            emptyCollectionTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyCollectionTitle.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
