import UIKit

final class FavouriteNftsViewController: UIViewController {
    // MARK: - Properties
    private var likesIds = [String]()

    private var viewModel: FavouriteNftsViewModelProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViews()
        setupConstraints()
        setUpBindings()
    }

    // MARK: - Init

    init(viewModel: FavouriteNftsViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI

    private func setupUI() {
        view.backgroundColor = .ypWhiteWithDarkMode
        view.tintColor = .ypBlackWithDarkMode
        title = NSLocalizedString("profile.mainScreen.favouritesNFT", tableName: "Localizable", comment: "Favourite NFT")
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavouriteNftsCollectionViewCell.self)
        return collectionView
    }()
    
    private func setupViews() {
        setupBackButtonItem()
        view.setupView(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    // MARK: - SetupUI
    
    private func setUpBindings() {
        viewModel?.nftCardsObservable.bind { [weak self] _ in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.collectionView.reloadData, with: ())
        }
        
        viewModel?.profileObservable.bind { [weak self] profile in
            guard let self else { return }
            self.likesIds = profile?.likes ?? []
            self.viewModel?.fetchNtfCards(likes: self.likesIds)
        }
        
        viewModel?.showErrorAlert = { [weak self] message in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.showNotificationBanner, with: message)
        }
    }
}

extension FavouriteNftsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return viewModel?.nftCardsObservable.wrappedValue?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavouriteNftsCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.backgroundColor = .clear
        guard let nft = viewModel?.nftCardsObservable.wrappedValue?[indexPath.row],
              let users = viewModel?.usersObservable.wrappedValue else { return cell }
        cell.delegate = self
        cell.setupCellData(.init(name: nft.name,
                                 images: nft.images,
                                 rating: nft.rating,
                                 price: nft.price,
                                 author: users.first(where: { $0.id == nft.author })?.name ?? "",
                                 id: nft.id,
                                 isLiked: likesIds.contains(nft.id),
                                 isAddedToCard: false))
        return cell
    }
}

extension FavouriteNftsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 15) / 2, height: 80)
    }
}

extension FavouriteNftsViewController: FavouriteNftsCollectionViewCellDelegate {
    func didTapLikeButton(id: String) {
        if likesIds.contains(id) {
            likesIds.removeAll { $0 == id }
        } else {
            likesIds.append(id)
        }
        collectionView.reloadData()
        viewModel?.changeProfile(likesIds: likesIds)
    }
}
