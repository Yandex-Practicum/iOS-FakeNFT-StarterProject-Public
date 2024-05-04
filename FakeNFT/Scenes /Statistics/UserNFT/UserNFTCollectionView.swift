//
//  UserNFTCollectionView.swift
//  FakeNFT
//
//  Created by Сергей on 25.04.2024.
//

import UIKit

protocol UserNFTCollectionViewProtocol {
    var presenter: UserNFTCollectionPresenterProtocol { get set }
}

final class UserNFTCollectionView: UIViewController & UserNFTCollectionViewProtocol {
    
    var presenter: UserNFTCollectionPresenterProtocol = UserNFTCollectionPresenter()
    
    init(nft: [NFTModel]) {
        presenter.visibleNFT = nft
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var nftCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(UserNFTCollectionCell.self, forCellWithReuseIdentifier: UserNFTCollectionCell.identifier)
        
        return collection
    }()
    
    private lazy var emptyCollectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "У пользователя еще нет NFT"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Коллекция NFT"
        view.backgroundColor = .systemBackground
        setViews()
        setConstraints()
        updateEmptyView()
    }
    
    private func setViews() {
        [nftCollection, emptyCollectionLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nftCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyCollectionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyCollectionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func updateEmptyView() {
        if presenter.visibleNFT.isEmpty {
            emptyCollectionLabel.isHidden = false
        } else {
            emptyCollectionLabel.isHidden = true
        }
    }
}

// MARK: - UICollectionViewDataSource

extension UserNFTCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.visibleNFT.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserNFTCollectionCell.identifier,
                                                            for: indexPath) as? UserNFTCollectionCell
        else {
            return UICollectionViewCell()
        }
        let nft = presenter.visibleNFT[indexPath.row]
        cell.set(nft: nft)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension UserNFTCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 52) / 3, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16)
    }
}
