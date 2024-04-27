import UIKit

//MARK: - CollectionOfUsersNftViewController
final class CollectionOfUsersNftViewController: UIViewController {
    
    private var servicesAssembly: ServicesAssembly
    private var collectionOfNftFabric: CollectionOfNftFabric
    private let collectionParams = GeometricParams(
        heightCell: 172,
        cellCount: 3,
        leftInset: 0,
        rightInset: 0,
        cellSpacing: 10
    )
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(resource: .ypWhite)
        return collectionView
    }()
    
    private lazy var backwardButton: UIBarButtonItem = {
        let sortButton = UIBarButtonItem(title: "",
                                         style: .plain,
                                         target: self,
                                         action: #selector(backwardButtonAction))
        sortButton.image = UIImage(resource: .backward).withTintColor(UIColor(resource: .ypBlack), renderingMode: .alwaysOriginal)
        return sortButton
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.font = UIFont.sfProBold17
        placeholderLabel.isHidden = true
        placeholderLabel.text = NSLocalizedString("Statistic.collectionsOfNft.emptyNfts", comment: "")
        return placeholderLabel
    }()
    
    init(with nfts: [String]?,
         servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        self.collectionOfNftFabric = CollectionOfNftFabric(
            with: nfts, servicesAssembly: servicesAssembly
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        activateUI()
    }
    
    //MARK: objc Methods
    @objc
    private func backwardButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - NavigationController
extension CollectionOfUsersNftViewController {
    
    func setupNavigation() {
        
        navigationController?.view.backgroundColor = UIColor(resource: .ypWhite)
        navigationController?.title = NSLocalizedString("Statistic.userCard.collectionOfNft", comment: "")
        navigationItem.leftBarButtonItem = backwardButton
    }
}

// MARK: - Add UI-Elements on View
extension CollectionOfUsersNftViewController {
    
    func activateUI() {
        
        setupCollection()
        activateConstraint()
        setupHiddensViews()
    }
    
    func setupCollection() {
        
        collection.delegate = self
        collection.dataSource = self
        collection.allowsMultipleSelection = false
        collection.allowsSelection = false
        collection.register(NftCell.self,
                            forCellWithReuseIdentifier: NftCell.identifier)
        collection.reloadData()
    }
    
    func activateConstraint() {
        
        [collection, placeholderLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            //MARK: Collection
            collection.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            collection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collection.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            placeholderLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            placeholderLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
    
    func setupHiddensViews() {
        
        collection.isHidden = collectionOfNftFabric.isEmpty()
        placeholderLabel.isHidden = !collectionOfNftFabric.isEmpty()
    }
}

//MARK: - UICollectionViewDataSource
extension CollectionOfUsersNftViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionOfNftFabric.getNftsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NftCell.identifier,
            for: indexPath) as? NftCell else {
            return UICollectionViewCell()
        }
        cell.prepareForReuse()
        
//        let nft = collectionOfNftFabric.getNft(by: indexPath.row)
//        cell.setNft(by: collectionOfNftFabric.getNft(by: indexPath.row))
        DispatchQueue.main.async {
            cell.configureCell(with: self.collectionOfNftFabric.getNft(by: indexPath.row))
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CollectionOfUsersNftViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let avaiableWidth = collectionView.frame.width - collectionParams.paddingWidth
        let cellWidth = avaiableWidth / CGFloat(collectionParams.cellCount)
        return CGSize(width: cellWidth,
                      height: collectionParams.heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        28
    }
}
