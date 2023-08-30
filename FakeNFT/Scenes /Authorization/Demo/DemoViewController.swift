import UIKit

final class DemoViewController: UIViewController {
    
    // MARK: Public dependencies
    var demoViewModel: DemoViewModelProtocol
    
    // MARK: UI constants and variables
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var totalView: UIView = {
        let totalView = UIView()
        totalView.backgroundColor = .lightGrayDay
        totalView.isHidden = false
        return totalView
    }()
    
    private lazy var totalNFT: UILabel = {
        let totalNFT = UILabel()
        totalNFT.textColor = .blackDay
        totalNFT.font = .captionSmallRegular
        return totalNFT
    }()
    
    private lazy var totalCost: UILabel = {
        let totalCost = UILabel()
        totalCost.textColor = .greenUniversal
        totalCost.font = .captionMediumBold
        return totalCost
    }()
    
    private lazy var toPayButton: UIButton = {
        let toPayButton = UIButton()
        toPayButton.backgroundColor = .blackDay
        toPayButton.setTitle(L10n.Cart.MainScreen.toPayButton, for: .normal)
        toPayButton.setTitleColor(.whiteDay, for: .normal)
        toPayButton.layer.cornerRadius = 16
        toPayButton.titleLabel?.textAlignment = .center
        toPayButton.titleLabel?.font = .captionMediumBold
        return toPayButton
    }()
    
    private let demoTabProfile: UIImageView = {
        let profile = UIImageView()
        profile.image = Resources.Images.TabBar.profileImage
        return profile
    }()
    
    private let demoTabCatalog: UIImageView = {
        let catalog = UIImageView()
        catalog.image = Resources.Images.TabBar.catalogImage
        return catalog
    }()
    
    private let demoTabCart: UIImageView = {
        let cart = UIImageView()
        cart.image = Resources.Images.TabBar.cartImageSelected
        return cart
    }()
    
    private let demoTabStatistic: UIImageView = {
        let statistic = UIImageView()
        statistic.image = Resources.Images.TabBar.statisticImage
        return statistic
    }()
    
    private lazy var demoTabBar: UIView = {
        let demoTabBar = UIView()
        demoTabBar.backgroundColor = .whiteUniversal
        return demoTabBar
    }()
    
    private let tabBarProfileLabel: UILabel = {
        let profile = UILabel()
        profile.font = .captionSmallestMedium
        profile.text = L10n.Profile.title
        return profile
    }()
    
    private let tabBarCatalogLabel: UILabel = {
        let catalog = UILabel()
        catalog.font = .captionSmallestMedium
        catalog.text = L10n.Catalog.title
        return catalog
    }()
    
    private let tabBarCartLabel: UILabel = {
        let profile = UILabel()
        profile.font = .captionSmallestMedium
        profile.text = L10n.Basket.title
        profile.textColor = .blueUniversal
        return profile
    }()
    
    private let tabBarStatisticLabel: UILabel = {
        let profile = UILabel()
        profile.font = .captionSmallestMedium
        profile.text = L10n.Statistic.title
        return profile
    }()
    
    private lazy var goBackButton: UIButton = {
        let goBackButton = UIButton()
        goBackButton.setImage(UIImage(systemName: "chevron.left")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal), for: .normal)
        return goBackButton
    }()
    
    // MARK: - Lifecycle:
    init(demoViewModel: DemoViewModel) {
        self.demoViewModel = demoViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setTargets()
        makeCollectionView()
        bind()
        blockUI()
    }
    
    private func bind() {
        
        demoViewModel.authorName.bind {[weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.totalNFT.text = "\(self.demoViewModel.additionNFT()) NFT"
                self.totalCost.text = "\(self.demoViewModel.additionPriceNFT()) ETH"
                self.unblockUI()
            }
        }
    }
}

// MARK: Set Up UI
extension DemoViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        [totalView, totalNFT, totalCost, toPayButton, collectionView, demoTabBar, goBackButton].forEach(view.setupView)
        [demoTabProfile, demoTabCatalog, demoTabCart, demoTabStatistic, tabBarCartLabel, tabBarCatalogLabel, tabBarProfileLabel, tabBarStatisticLabel].forEach(demoTabBar.setupView)
    }
    
    private func setupConstraints() {
        
        // Main
        NSLayoutConstraint.activate([
            totalView.bottomAnchor.constraint(equalTo: demoTabBar.topAnchor),
            totalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            totalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            totalView.heightAnchor.constraint(equalToConstant: 76),
            totalNFT.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 16),
            totalNFT.leadingAnchor.constraint(equalTo: totalView.leadingAnchor, constant: 16),
            totalCost.topAnchor.constraint(equalTo: totalNFT.bottomAnchor, constant: 2),
            totalCost.leadingAnchor.constraint(equalTo: totalView.leadingAnchor, constant: 16),
            toPayButton.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 16),
            toPayButton.trailingAnchor.constraint(equalTo: totalView.trailingAnchor, constant: -16),
            toPayButton.widthAnchor.constraint(equalToConstant: 240),
            toPayButton.heightAnchor.constraint(equalToConstant: 44),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: totalView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            demoTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            demoTabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            demoTabBar.widthAnchor.constraint(equalToConstant: 375),
            demoTabBar.heightAnchor.constraint(equalToConstant: 83),
            goBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // TabBar
        NSLayoutConstraint.activate([
            demoTabProfile.topAnchor.constraint(equalTo: demoTabBar.topAnchor, constant: 4),
            demoTabProfile.leadingAnchor.constraint(equalTo: demoTabBar.leadingAnchor, constant: 30),
            tabBarProfileLabel.topAnchor.constraint(equalTo: demoTabProfile.bottomAnchor, constant: 0.87),
            tabBarProfileLabel.centerXAnchor.constraint(equalTo: demoTabProfile.centerXAnchor),
            demoTabCatalog.topAnchor.constraint(equalTo: demoTabBar.topAnchor, constant: 4),
            demoTabCatalog.leadingAnchor.constraint(equalTo: demoTabBar.leadingAnchor, constant: 125),
            tabBarCatalogLabel.topAnchor.constraint(equalTo: demoTabCatalog.bottomAnchor, constant: 0.87),
            tabBarCatalogLabel.centerXAnchor.constraint(equalTo: demoTabCatalog.centerXAnchor),
            demoTabCart.topAnchor.constraint(equalTo: demoTabBar.topAnchor, constant: 4),
            demoTabCart.leadingAnchor.constraint(equalTo: demoTabBar.leadingAnchor, constant: 220),
            tabBarCartLabel.topAnchor.constraint(equalTo: demoTabCart.bottomAnchor, constant: 0.87),
            tabBarCartLabel.centerXAnchor.constraint(equalTo: demoTabCart.centerXAnchor),
            demoTabStatistic.topAnchor.constraint(equalTo: demoTabBar.topAnchor, constant: 4),
            demoTabStatistic.leadingAnchor.constraint(equalTo: demoTabBar.leadingAnchor, constant: 315),
            tabBarStatisticLabel.topAnchor.constraint(equalTo: demoTabStatistic.bottomAnchor, constant: 0.87),
            tabBarStatisticLabel.centerXAnchor.constraint(equalTo: demoTabStatistic.centerXAnchor)
        ])
    }
    
    private func setTargets() {
        goBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        toPayButton.addTarget(self, action: #selector(toPay), for: .touchUpInside)
    }
    
    private func makeCollectionView() {
        collectionView.register(DemoCell.self)
        collectionView.backgroundColor = .whiteDay
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc private func goBack() {
        dismiss(animated: true)
    }
    
    @objc private func toPay() {
    // demo
    }
}

// MARK: Collection View
extension DemoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cartNFT = demoViewModel.unwrappedCartNftViewModel()
        return cartNFT.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DemoCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let cartNFT = demoViewModel.unwrappedCartNftViewModel()
        let model = cartNFT[indexPath.row]
        let authorName = demoViewModel.unwrappedAuthorViewModel()
        cell.setupCollectionModel(model: model, author: authorName)
        return cell
    }
}

extension DemoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
