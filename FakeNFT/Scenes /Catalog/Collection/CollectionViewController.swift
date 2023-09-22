import UIKit
import Kingfisher

final class CollectionViewController: UIViewController {
    
    private let viewModel: CollectionViewModel
 
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.register(DescriptionCollectionViewCell.self, forCellWithReuseIdentifier: DescriptionCollectionViewCell.identifier)
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(viewModel: CollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.reloadData = self.collectionView.reloadData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        
        addSubviews()
        setupConstraints()
    }
        
    private func addSubviews() {
        [collectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func likeButtonTapped(nftIndex: String) {
        viewModel.updateLikeForNFT(with: nftIndex)
    }
    
    private func cartButton(nftIndex: String) {
        viewModel.isNFTInOrder(with: nftIndex)
    }
}

//MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let section = CollectionNFTSection(rawValue: section) else { return .zero }
        switch section {
        case .image:
            return 1
        case .description:
            return 1
        case .nft:
            return viewModel.collection.nfts.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let section = CollectionNFTSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch section {
            
        case .image:
            guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
            if let imageURLString = viewModel.collection.cover,
               let imageURl = URL(string: imageURLString.encodeURL) {
                imageCell.imageView.kf.setImage(with: imageURl)
            }
            return imageCell
            
        case .description:
            guard let descriptionCell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCollectionViewCell.identifier, for: indexPath) as? DescriptionCollectionViewCell else { return UICollectionViewCell() }
            descriptionCell.configure(collectionName: viewModel.collection.name, subTitle: "Автор коллекции:", authorName: viewModel.user?.name ?? "Jack Noris", description: viewModel.collection.description)
            return descriptionCell
            
        case .nft:
            var likeButton: String
            var cartButton: String
            
            guard let nftCell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as? NFTCollectionViewCell else { return UICollectionViewCell() }
            
            let nftIndex = viewModel.collection.nfts[indexPath.row]
            
            if let imageURLString = viewModel.nfts(by: nftIndex)?.images.first,
               let imageURL = URL(string: imageURLString.encodeURL),
               let price = viewModel.nfts(by: nftIndex)?.price.ethCurrency,
               let rating = viewModel.nfts(by: nftIndex)?.rating {
                let isNFTLiked = viewModel.isNFTLiked(with: nftIndex)
                let isNFTInOrder = viewModel.isNFTInOrder(with: nftIndex)
                
                likeButton = isNFTLiked ? "like" : "dislike"
                cartButton = isNFTInOrder ? "inCart" : "cart"
                
                nftCell.configure(nftImage: imageURL, likeOrDislike: likeButton, rating: rating, nftName: viewModel.nfts(by: nftIndex)?.name ?? "", pirce: price, cartImage: cartButton, likeButtonInteraction: { [weak self] in
                    self?.likeButtonTapped(nftIndex: nftIndex)
                },
                                  cartButtonInteraction: { [weak self] in
                    self?.cartButton(nftIndex: nftIndex)
                })
            }
            return nftCell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        CollectionNFTSection.allCases.count
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let section = CollectionNFTSection(rawValue: indexPath.section) else { return .zero }
        switch section {
        case .image:
            return CGSize(width: self.collectionView.bounds.width, height: 310)
        case .description:
            return CGSize(width: self.collectionView.bounds.width, height: 160)
        case .nft:
            let bounds = UIScreen.main.bounds
            let width = (bounds.width - 50) / 3
            return CGSize(width: width, height: 200)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        guard let section = CollectionNFTSection(rawValue: section) else { return .zero }
        switch section {
        case .image:
            return .zero
        case .description:
            return .zero
        case .nft:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}
