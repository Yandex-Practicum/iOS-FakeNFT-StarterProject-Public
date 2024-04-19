import UIKit

//MARK: - CollectionOfUsersNftViewController
final class CollectionOfUsersNftViewController: UIViewController {
    
    private var servicesAssembly: ServicesAssembly
    private var collectionOfNftFabric = CollectionOfNftFabric()
    
    lazy private var collection: UICollectionView = {
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
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
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
        navigationController?.title = "Коллекция NFT"
        navigationItem.leftBarButtonItem = backwardButton
    }
}

// MARK: - Add UI-Elements on View
extension CollectionOfUsersNftViewController {
    
    func activateUI() {
        
        setupCollection()
        activateConstraint()
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
        
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            collection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collection.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
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
        
        let nft = collectionOfNftFabric.getNft(by: indexPath.row)
        cell.configureCell(with: nft)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CollectionOfUsersNftViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let avaiableWidth = collectionView.frame.width - (10*2)
        let cellWidth = avaiableWidth / CGFloat(3)
        return CGSize(width: cellWidth, height: 172)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        28
    }
}
