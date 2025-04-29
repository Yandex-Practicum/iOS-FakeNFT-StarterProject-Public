//
//  NFTCollectionViewController.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/26/25.
//
import UIKit

final class NFTCollectionViewController: UIViewController {
    // MARK: - Private properties
    private let nftCollectionView = NFTCollectionView()
    private var nfts: [NFTCollectionModel] = []
    private let nftCollectionService = NFTCollectionService.shared
    private var nftCollectionServiceObserver: NSObjectProtocol?
    // MARK: - Lifecycle
    override func loadView() {
        self.view = nftCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nftCollectionView.configure()
        setupNavigationBar()
        setupCollectionView()
        setupObserver()
    }
    // MARK: - Selectors
    @objc private func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Private Methods
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        backButton.tintColor = .segmentActive
        self.navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "Коллекция NFT"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupCollectionView() {
        nftCollectionView.collectionView.delegate = self
        nftCollectionView.collectionView.dataSource = self
    }
    
    private func setupObserver() {
        nftCollectionServiceObserver = NotificationCenter.default
            .addObserver(forName: NFTCollectionService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self else { return print("error") }
                nfts = nftCollectionService.nfts
                nftCollectionView.collectionView.reloadData()
                hideActivityIndicator()
            }
    }
    private func showActivityIndicator() {
        nftCollectionView.activityIndicator.startAnimating()
        nftCollectionView.collectionView.isHidden = true
        nftCollectionView.activityIndicator.isHidden = false
    }

    private func hideActivityIndicator() {
        nftCollectionView.activityIndicator.stopAnimating()
        nftCollectionView.collectionView.isHidden = false
        nftCollectionView.activityIndicator.isHidden = true
    }
    private func setupEmptyCollection() {
        nftCollectionView.activityIndicator.stopAnimating()
        nftCollectionView.collectionView.isHidden = true
        nftCollectionView.activityIndicator.isHidden = true
        nftCollectionView.emptyCollectionTitle.isHidden = false
    }
}

extension NFTCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 9
        let sideInset: CGFloat = 16
        let itemsPerRow: CGFloat = 3
        
        let totalCellWidth = collectionView.bounds.width - 2 * sideInset
        let totalSpacingWidth = spacing * CGFloat(itemsPerRow - 1)
        
        let itemWidth = (totalCellWidth - totalSpacingWidth) / itemsPerRow
                
        return CGSize(width: itemWidth, height: itemWidth * 1.78)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}

extension NFTCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.reuseIdentifier, for: indexPath) as? NFTCollectionViewCell else {
            return UICollectionViewCell()
        }
        let nft = nfts[indexPath.row]
        cell.configure(with: nft)
        return cell
    }
}

extension NFTCollectionViewController: GetNFTsCollectionDelegate {
    func getNFTs(of user: UsersListModel) {
        guard !user.nfts.isEmpty else {
            setupEmptyCollection()
            return
        }
        showActivityIndicator()
        nftCollectionService.fetchNFT(with: user.nfts)
    }
}
