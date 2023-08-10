import UIKit
import Kingfisher

final class FavoritesView: UIView {
    private let viewModel: FavoritesViewModelProtocol
    private(set) var likedNFTs: [NFTNetworkModel]?
    
    private lazy var favoriteNFTCollection: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FavoritesCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(frame: CGRect, viewModel: FavoritesViewModelProtocol) {
        self.viewModel = viewModel
        self.likedNFTs = viewModel.likedNFTs
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateNFT(nfts: [NFTNetworkModel]) {
        self.likedNFTs = nfts
        favoriteNFTCollection.reloadData()
    }
    
    private func setupConstraints() {
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
        guard let likedNFTs = likedNFTs,
              !likedNFTs.isEmpty else { return FavoritesCell() }
        let likedNFT = likedNFTs[indexPath.row]
        
        let model = FavoritesCell.Model(
            image: likedNFT.images.first ?? "",
            name: likedNFT.name,
            rating: likedNFT.rating,
            price: likedNFT.price,
            isFavorite: true,
            id: likedNFT.id
        )
        cell.tapAction = { [unowned viewModel] in
            viewModel.favoriteUnliked(id: likedNFT.id)
        }
        cell.configureCell(with: model)
        
        return cell
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
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
}

