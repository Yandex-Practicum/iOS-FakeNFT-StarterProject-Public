//
//  UserNFTCollectionView.swift
//  FakeNFT
//
//  Created by Сергей on 25.04.2024.
//

import UIKit


final class UserNFTCollectionView: UIViewController {
    
   
    
    
    private lazy var nftCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, 
                                          collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(UserNFTCollectionCell.self, forCellWithReuseIdentifier: UserNFTCollectionCell.identifier)
        
        return collection
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Коллекция NFT"
        view.backgroundColor = .systemBackground
        setViews()
        setConstraints()
    }
    
    
    private func setViews() {
        view.addSubview(nftCollection)
    }
    
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nftCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}


// MARK: - UICollectionViewDataSource

extension UserNFTCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserNFTCollectionCell.identifier, for: indexPath) as! UserNFTCollectionCell
        cell.set(image: UIImage(named: "mockNFT") ?? UIImage(), name: "Zeus", price: 1.78, rating: 3)
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
