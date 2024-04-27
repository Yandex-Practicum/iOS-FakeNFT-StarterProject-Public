//
//  FavoritesNFTViewController.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 11.04.2024.
//

import UIKit

protocol FavoritesNFTViewControllerProtocol: AnyObject {
    var presenter: FavoritesNFTPresenter? { get set }
    func updateFavoriteNFTs(_ likes: [NFT]?)
}

final class FavoritesNFTViewController: UIViewController {
    //MARK:  - Public Properties
    var presenter: FavoritesNFTPresenter?
    
    //MARK:  - Private Properties
    private var nftID: [String]
    private var likedNFT: [String]
    private let editProfileService = EditProfileService.shared
    
    private lazy var returnButton: UIBarButtonItem = {
        let button = UIBarButtonItem( image: UIImage(systemName: "chevron.left"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(returnButtonTap))
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()
    
    private lazy var favoritesNFTCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = UIColor(named: "ypWhite")
        collection.register(FavoritesNFTCell.self, forCellWithReuseIdentifier: FavoritesNFTCell.cellID)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var  stubLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас еще нет избранных NFT"
        label.font = UIFont.sfProBold17
        label.textColor = UIColor(named: "ypBlack")
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializers
    init(nftID: [String], likedID: [String]) {
        self.nftID = nftID
        self.likedNFT = likedID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    @objc func returnButtonTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingNavigation()
        customizingStub()
        customizingScreenElements()
        customizingTheLayoutOfScreenElements()
        presenter = FavoritesNFTPresenter(nftID: self.nftID, likedNFT: self.likedNFT, editProfileService: editProfileService)
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    //MARK: - Private Methods
    private func customizingStub () {
        view.addSubview(stubLabel)
        
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func customizingNavigation() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: "ypWhite")
        navigationItem.title = "Избранные NFT"
        navigationItem.leftBarButtonItem = returnButton
    }
    
    private func customizingScreenElements() {
        view.addSubview(favoritesNFTCollectionView)
    }
    
    private func customizingTheLayoutOfScreenElements() {
        NSLayoutConstraint.activate([
            favoritesNFTCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            favoritesNFTCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoritesNFTCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoritesNFTCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let presenter = presenter {
            if presenter.likes.isEmpty {
                stubLabel.isHidden = false
                favoritesNFTCollectionView.isHidden = true
            } else {
                stubLabel.isHidden = true
                favoritesNFTCollectionView.isHidden = false
            }
        } else {
            print("presenter is nil")
        }
        return presenter?.likes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesNFTCell.cellID, for: indexPath) as? FavoritesNFTCell else { fatalError("Failed to cast UICollectionViewCell to FavoritesNFTCell")
        }
        
        guard let likes = presenter?.likes[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.changingNFT(nft: likes)
        cell.delegate = self
        cell.setIsLikedNFT(likedNFT.contains(likes.id))
        cell.selectedBackgroundView = .none
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesNFTViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,
                            left: 16,
                            bottom: 20,
                            right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 168, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
}
// MARK: - FavoritesNFTViewControllerProtocol
extension FavoritesNFTViewController: FavoritesNFTViewControllerProtocol {
    func updateFavoriteNFTs(_ likes: [NFT]?) {
        guard let presenter = presenter else {
            print("Presenter is nil")
            return
        }
        
        guard let likes = likes else {
            print("Received nil Likes")
            return
        }
        presenter.likes = likes
        DispatchQueue.main.async {
            self.favoritesNFTCollectionView.reloadData()
        }
    }
}

// MARK: - FavoritesNFTViewControllerProtocol
extension FavoritesNFTViewController: FavoritesNFTCellDelegate {
    func didTapLikeButton(cell: FavoritesNFTCell) {
        guard let indexPath = favoritesNFTCollectionView.indexPath(for: cell) else { return }
        
        guard let like = presenter?.likes[indexPath.row] else { return }
        presenter?.tapLikeNFT(for: like)
        
    }
}
