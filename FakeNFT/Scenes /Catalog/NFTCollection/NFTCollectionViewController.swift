import UIKit

final class NFTCollectionViewController: UIViewController {
    private enum CollectionLayout {
        static let backButtonTop: CGFloat = 11
        static let backButtonLeading: CGFloat = 9
        static let backButtonSize: CGFloat = 24
        
        static let coverImageHeight: CGFloat = 310
        
        static let titleTop: CGFloat = 16
        static let titleLeading: CGFloat = 16
        static let titeTrailing: CGFloat = -16
        
        static let authorTop: CGFloat = 8
        static let authorSpacing: CGFloat = 4
        
        static let descriptionTop: CGFloat = 4
        
        static let collectionTop: CGFloat = 24
        static let collectionLeading: CGFloat = 16
        static let collectionTrailing: CGFloat = -16
        static let collectionBottom: CGFloat = -16
        static let collectionBottomInset: CGFloat = 16
        
        static let interItemSpacing: CGFloat = 10
        static let lineSpacing: CGFloat = 8
        
        static let itemsPerRow: Int = 3
        
        static let itemWidth: CGFloat = 108
        static let itemHeight: CGFloat = 192
    }
    
    // MARK: - UI
    private let backButton = UIButton(type: .system)
    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let webLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let collectionView: UICollectionView
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var collectionHeightConstraint: NSLayoutConstraint?
    
    private let collection: Catalog
    
    
    
    // MARK: - MVP
    var output: NFTCollectionViewOutput?
    
    // MARK: - Data
    private var nfts: [Nft] = []
    private var favorites: Set<String> = []
    private var itemsInCart: Set<String> = []
    private var imageCache: [String: UIImage] = [:]
    private var imageLoading: Set<String> = []

    
    // MARK: - Init
    init(collection: Catalog) {
        self.collection = collection
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let totalWidth = UIScreen.main.bounds.width
        let horizontalInsets = CollectionLayout.collectionLeading + abs(CollectionLayout.collectionTrailing)
        let availableWidth = totalWidth - horizontalInsets
        
        let totalSpacing = CGFloat(CollectionLayout.itemsPerRow - 1) * CollectionLayout.interItemSpacing
        
        let itemWidth = (availableWidth - totalSpacing) / CGFloat(CollectionLayout.itemsPerRow)
        
        layout.itemSize = CGSize(width: itemWidth, height: CollectionLayout.itemHeight)
        layout.minimumInteritemSpacing = CollectionLayout.interItemSpacing
        layout.minimumLineSpacing = CollectionLayout.lineSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: CollectionLayout.collectionBottomInset,
            right: 0
        )
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        setupViews()
        setupLayout()
        setupCollection()
        applyCollectionHeader()
        
        output?.viewDidLoad()
    }
    
    private func updateCollectionHeight() {
        collectionView.layoutIfNeeded()
        collectionHeightConstraint?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func applyCollectionHeader() {
        titleLabel.text = collection.name
        descriptionLabel.text = collection.description
        configureAuthorLabels(with: collection.author)

        guard let url = URL(string: collection.cover) else {
            return
        }
        ImageLoader.shared.load(url) { image in
            self.coverImageView.image = image
        }
    }
    
    private func configureAuthorLabels(with text: String) {
        let components = text.components(separatedBy: ":")
        
        guard components.count >= 2 else {
            authorLabel.text = "Автор коллекции: "
            webLabel.text = text
            return
        }
        
        let prefix = components[0] + ":"
        let authorName = components[1].trimmingCharacters(in: .whitespaces)
        authorLabel.text = prefix
        webLabel.text = authorName
    }
    
    private lazy var authorStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [authorLabel, webLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = CollectionLayout.authorSpacing
        return stack
    }()
    
    
    
    // MARK: - Setup
    private func setupViews() {
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .label
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)

        authorLabel.font = .systemFont(ofSize: 13, weight: .regular)
        authorLabel.textColor = .blackUniversal

        webLabel.font = .systemFont(ofSize: 15, weight: .regular)
        webLabel.textColor = .blueUniversal
        webLabel.isUserInteractionEnabled = true
        webLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(webTapped)))

        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .blackUniversal
        descriptionLabel.numberOfLines = 0

        activityIndicator.hidesWhenStopped = true

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        [backButton,
         coverImageView,
         titleLabel,
         authorStack,
         descriptionLabel,
         collectionView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CollectionLayout.backButtonTop),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CollectionLayout.backButtonLeading),
            backButton.widthAnchor.constraint(equalToConstant: CollectionLayout.backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: CollectionLayout.backButtonSize),

            coverImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: CollectionLayout.coverImageHeight),

            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: CollectionLayout.titleTop),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CollectionLayout.titleLeading),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: CollectionLayout.titeTrailing),

            authorStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CollectionLayout.authorTop),
            authorStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorStack.trailingAnchor.constraint(lessThanOrEqualTo: titleLabel.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: authorStack.bottomAnchor, constant: CollectionLayout.descriptionTop),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: CollectionLayout.collectionTop),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CollectionLayout.collectionLeading),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: CollectionLayout.collectionTrailing),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CollectionLayout.collectionBottom),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionHeightConstraint?.isActive = true
    }

    
    private func setupCollection() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NFTCollectionCell.self, forCellWithReuseIdentifier: "NFTCollectionCell")
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        output?.didTapBack()
    }
    
    @objc private func webTapped() {
        if let url = URL(string: "https://practicum.yandex.ru/catalog/programming/?from=main_programming_card&searchText=ios") {
            let vc = WebViewController(url: url)

            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            (tabBarController ?? self).present(nav, animated: true)
        }
    }

    
}

// MARK: - UICollectionViewDataSource
extension NFTCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nfts.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "NFTCollectionCell",
            for: indexPath
        ) as? NFTCollectionCell else {
            return UICollectionViewCell()
        }
        
        let nft = nfts[indexPath.item]
        let isFavorite = favorites.contains(nft.id)
        let inCart = itemsInCart.contains(nft.id)

        let viewModel = NFTCollectionCell.ViewModel(
            title: nft.name,
            author: nft.author,
            priceText: String(format: "%.2f", nft.price),
            isFavorite: isFavorite,
            inCart: inCart,
            image: imageCache[nft.id],
            rating: nft.rating
        )

        cell.configure(with: viewModel)
        cell.delegate = self

        loadImageIfNeeded(for: nft, at: indexPath)

        return cell
    }
    
    private func loadImageIfNeeded(for nft: Nft, at indexPath: IndexPath) {
        guard imageCache[nft.id] == nil else { return }
        guard imageLoading.insert(nft.id).inserted else { return }
        guard let first = nft.images.first, let url = URL(string: first) else {
            imageLoading.remove(nft.id)
            return
        }

        ImageLoader.shared.load(url) { [weak self] image in
            guard let self else { return }
            self.imageLoading.remove(nft.id)

            if let image {
                self.imageCache[nft.id] = image
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
    }

}

private extension NFTCollectionViewController {
    static func makeImage(from url: URL?) -> UIImage? {
        guard let url else { return nil }
        
        if url.scheme == "asset" {
            let assetName = url.host ?? url.path.replacingOccurrences(of: "/", with: "")
            return UIImage(named: assetName)
        }
        
        return nil
    }
}

// MARK: - UICollectionViewDelegate
extension NFTCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nft = nfts[indexPath.item]
        output?.didSelectNft(with: nft.id)
    }
}

// MARK: - NFTCollectionCellDelegate
extension NFTCollectionViewController: NFTCollectionCellDelegate {
    func nftCellDidTapFavorite(_ cell: NFTCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let nft = nfts[indexPath.item]
        output?.didToggleFavorite(for: nft.id)
    }
    
    func nftCellDidTapCart(_ cell: NFTCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let nft = nfts[indexPath.item]
        output?.didToggleCart(for: nft.id)
    }
}

// MARK: - NFTCollectionViewInput
extension NFTCollectionViewController: NFTCollectionViewInput {
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateNfts(_ nfts: [Nft]) {
        self.nfts = nfts
        collectionView.reloadData()
        updateCollectionHeight()
    }
    
    func updateFavorites(_ favorites: [String]) {
        self.favorites = Set(favorites)
        collectionView.reloadData()
    }
    
    func updateCart(_ itemsInCart: [String]) {
        self.itemsInCart = Set(itemsInCart)
        collectionView.reloadData()
    }
}




