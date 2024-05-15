//
//  UserNFTCollectionView.swift
//  FakeNFT
//
//  Created by Сергей on 25.04.2024.
//

import UIKit
import ProgressHUD

final class UserNFTCollectionView: UIViewController {
    
    private let service = UserNFTService.shared
    
    init(nft: [String]) {
        self.service.nftsIDs = nft
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
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
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        navigationItem.title = "Коллекция NFT"
        view.backgroundColor = .systemBackground
        setViews()
        setConstraints()
        service.getNFT {
            self.nftCollection.reloadData()
            self.updateEmptyView()
            UIBlockingProgressHUD.dismiss()
        }
        service.getProfile()
        service.getCart()
    }
    
    private func setViews() {
        [nftCollection, emptyCollectionLabel, activityIndicator].forEach {
            view.addSubview($0)
        }
        activityIndicator.center = view.center
        UIBlockingProgressHUD.show()
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
        if service.visibleNFT.isEmpty {
            emptyCollectionLabel.isHidden = false
        } else {
            emptyCollectionLabel.isHidden = true
        }
    }
    
    @objc func customBackAction() {
        navigationController?.popViewController(animated: true)
        service.visibleNFT = []
    }
}

// MARK: - UICollectionViewDataSource

extension UserNFTCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        service.visibleNFT.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserNFTCollectionCell.identifier,
                                                            for: indexPath) as? UserNFTCollectionCell
                
        else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        let nft = service.visibleNFT[indexPath.row]
        if let profile = service.profile,
           let cart = service.cart
        {
            cell.set(nft: nft, cart: cart, profile: profile)
        } else {
            assertionFailure("error profile unwrap")
            
        }
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

extension UserNFTCollectionView: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(customBackAction))
            navigationItem.leftBarButtonItem = backButton
            
        }
    }
}

extension UserNFTCollectionView: UserNFTCellDelegate {
    func addToCartButtonClicked(_ cell: UserNFTCollectionCell, nft: NFTModel) {
        guard let order = service.cart else { return }
        
        var cart = order.nfts
        let id = nft.id
        var isAdded = false
        if cart.contains(id) {
            cart.removeAll { $0 == id }
            isAdded = false
        } else {
            cart.append(id)
            isAdded = true
        }
        UIBlockingProgressHUD.show()
        service.changeCart(newCart: cart) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.service.getCart()
                    cell.setIsAdded(isAdded: isAdded)
                    UIBlockingProgressHUD.dismiss()
                    print("success")
                case .failure(_):
                    print("error")
                    UIBlockingProgressHUD.dismiss()
                    break
                    
                }
            }
        }
        
    }
    
    func addFavouriteButtonClicked(_ cell: UserNFTCollectionCell, nft: NFTModel) {
        guard let profile = service.profile else { return }
        var likes = profile.likes
        let id = nft.id
        var isLiked = false
        if likes.contains(id) {
            likes.removeAll { $0 == id }
            isLiked = false
        } else {
            likes.append(id)
            isLiked = true
        }
        
        UIBlockingProgressHUD.show()
        
        service.changeLike(newLikes: likes) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    cell.setIsLiked(isLiked: isLiked)
                    self?.service.getProfile()
                    UIBlockingProgressHUD.dismiss()
                    print("success")
                case .failure(_):
                    print("error")
                }
            }
        }
    }
}
