import UIKit

final class MyNftsViewController: UIViewController {
    // MARK: - Properties

    var likeNFTIds = [String]()
    var nftIds = [String]()

    private var viewModel: MyNFTViewModelProtocol?
    private var alertService: AlertServiceProtocol?
    private lazy var dataProvider = ProfileDataProvider()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViews()
        setupConstraints()
        setUpBindings()
    }
    
    // MARK: - Init

    init(viewModel: MyNFTViewModel?) {
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
        title = NSLocalizedString("profile.myNFT.title", tableName: "Localizable", comment: "My Nft")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Resources.Images.NavBar.sortIcon,
            style: .plain, target: self,
            action: #selector(sortButtonTapped)
        )
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyNFTCollectionViewCell.self)
        return collectionView
    }()
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViews() {
        setupBackButtonItem()
        view.setupView(collectionView)
    }
    
    private func sortNFT(_ sortOptions: SortingOption) {
        alertService = nil
        viewModel?.sortNFTCollection(option: sortOptions)
    }
    // MARK: - SetupBindings
    private func setUpBindings() {
        viewModel?.nftCardsObservable.bind { [weak self] _ in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.collectionView.reloadData, with: ())
        }
        
        viewModel?.profileObservable.bind { [weak self] profile in
            guard let self else { return }
            self.nftIds = profile?.nfts ?? []
            self.likeNFTIds = profile?.likes ?? []
            self.viewModel?.fetchNtfCards(nftIds: self.nftIds)
        }
        
        viewModel?.showErrorAlert = { [weak self] message in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.showNotificationBanner, with: message)
        }
    }

    // MARK: - Actions
    @objc private func sortButtonTapped() {
        alertService = UniversalAlertService()
        alertService?.showActionSheet(title: NSLocalizedString("sorting.title",tableName: "Localizable", comment: "Sorting title"),
                                      sortingOptions: [.byPrice, .byRating, .byName, .close],
                                      on: self,
                                      completion: { [weak self] options in
            guard let self else { return }
            self.sortNFT(options)
        })
    }
}

// MARK: - UICollectionViewDelegate&UICollectionViewDataSource
extension MyNftsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.nftCardsObservable.wrappedValue?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyNFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
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
                                 isLiked: likeNFTIds.contains(nft.id),
                                 isAddedToCard: false))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyNftsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 108)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 32
    }
}

extension MyNftsViewController: MyNFTCollectionViewCellDelegate {
    func didTapLikeButton(id: String) {
        if likeNFTIds.contains(id) {
            likeNFTIds.removeAll { $0 == id }
        } else {
            likeNFTIds.append(id)
        }

        collectionView.reloadData()
        viewModel?.changeProfile(likesIds: likeNFTIds)
    }

}
