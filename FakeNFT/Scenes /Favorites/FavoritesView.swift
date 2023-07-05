import UIKit
import Kingfisher

final class FavoritesView: UIView {
    // MARK: - Properties
    private var viewController: FavoritesViewController?
    
    private(set) var likedNFTs: [NFTNetworkModel]?
    
    //MARK: - Layout elements
    private lazy var favoriteNFTCollection: UICollectionView = {
        let favoriteNFTCollection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        favoriteNFTCollection.translatesAutoresizingMaskIntoConstraints = false
        favoriteNFTCollection.register(FavoritesCell.self)
        favoriteNFTCollection.dataSource = self
        favoriteNFTCollection.delegate = self
        return favoriteNFTCollection
    }()
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewController: FavoritesViewController) {
        super.init(frame: frame)
        self.viewController = viewController

        
        self.backgroundColor = .white
        addCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //
    // MARK: - Methods
    func updateNFT(nfts: [NFTNetworkModel]) {
        self.likedNFTs = nfts
        favoriteNFTCollection.reloadData()
//        UIBlockingProgressHUD.dismiss()
    }
    
    //MARK: - Layout methods
    private func addCollection() {
        addSubview(favoriteNFTCollection)
        
        NSLayoutConstraint.activate([
            favoriteNFTCollection.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            favoriteNFTCollection.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            favoriteNFTCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            favoriteNFTCollection.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension FavoritesView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let likedNFTs = likedNFTs else { return 0 }
        return likedNFTs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoritesCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.backgroundColor = .white
        guard let likedNFT = likedNFTs?[indexPath.row] else { return FavoritesCell() }
        cell.nftImage.kf.setImage(with: URL(string: likedNFT.images[0]))
        cell.nftName.text = likedNFT.name
        cell.nftRating.setStarsRating(rating: likedNFT.rating)
        cell.nftPriceValue.text = "\(likedNFT.price) ETH"
        cell.nftFavorite.nftID = likedNFT.id
        cell.nftFavorite.isFavorite = true
        cell.nftFavorite.addTarget(self, action: #selector(didTapFavoriteButton(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc
    func didTapFavoriteButton(sender: FavoriteButton) {
        sender.isFavorite.toggle()
        // TODO: Favorite functionality
    }
}

extension FavoritesView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 16 * 2 - 7
        return CGSize(width: availableWidth / 2, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
    
}

//extension MyNFTView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let myNFTs = myNFTs else { return 0 }
//        return myNFTs.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: MyNFTCell = tableView.dequeueReusableCell()
//        cell.backgroundColor = .white
//        cell.selectionStyle = .none
//        guard let myNFT = myNFTs?[indexPath.row] else { return MyNFTCell() }
//        cell.nftImage.kf.setImage(with: URL(string: myNFT.images[0]))
//        cell.nftName.text = myNFT.name
//        cell.nftRating.setStarsRating(rating: myNFT.rating)
//        if let authorName = viewController?.getAuthorById(id: myNFT.author) {
//            cell.nftAuthor.text = "от \(authorName)"}
//        cell.nftPriceValue.text = "\(myNFT.price) ETH"
//        cell.nftFavorite.nftID = myNFT.id
//        cell.nftFavorite.isFavorite = false
//        cell.nftFavorite.addTarget(self, action: #selector(didTapFavoriteButton(sender:)), for: .touchUpInside)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 140
//    }
//
//    @objc
//    func didTapFavoriteButton(sender: FavoriteButton) {
//        sender.isFavorite.toggle()
//        // TODO: Favorite functionality
//    }
//}
//
//extension MyNFTView: UITableViewDelegate {
//
//}
