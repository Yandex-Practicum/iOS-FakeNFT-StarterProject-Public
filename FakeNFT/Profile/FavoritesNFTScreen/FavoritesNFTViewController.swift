import UIKit

final class FavoritesNFTViewController: UIViewController {
    
    // MARK: - UI properties
    
    private let geometricParams: GeometricParams = {
        GeometricParams(cellPerRowCount: 2,
                        cellSpacing: 7,
                        cellLeftInset: 16,
                        cellRightInset: 16,
                        cellHeight: 80)
    }()
    
    private lazy var nftCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.register(FavoritesNFTCell.self)
        return collection
    }()
    
    private lazy var noNFTLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("FavoritesNFTViewController.nonft", comment: "")
        label.font = .bodyBold
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    
    private let viewModel: FavoritesNFTViewModelProtocol
    private let nftList: [String]
    
    // MARK: - Lifecycle
    
    init(nftList: [String], viewModel: FavoritesNFTViewModelProtocol) {
        self.nftList = nftList
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad(nftList: self.nftList)
        
        configNavigationBar()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    // MARK: - Methods
    
    private func bind() {
        viewModel.observeFavoritesNFT { [weak self] _ in
            guard let self = self else { return }
            self.nftCollectionView.reloadData()
        }
        
        viewModel.observeState { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.setUIInteraction(false)
            case .loaded(let hasData):
                self.updateUI(isNoNFT: !hasData)
                self.nftCollectionView.reloadData()
            case .error(_):
                print("Ошибка")
            default:
                break
            }
        }
    }
    
    private func setUIInteraction(_ enabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.nftCollectionView.isUserInteractionEnabled = enabled
            self?.navigationItem.leftBarButtonItem?.isEnabled = enabled
            self?.nftCollectionView.alpha = enabled ? 1.0 : 0.5
        }
    }
    
    private func updateUI(isNoNFT: Bool) {
        setUIInteraction(true)
        self.noNFTLabel.isHidden = !isNoNFT
        navigationItem.title = isNoNFT ? nil : NSLocalizedString("ProfileViewController.favouritesNFT", comment: "")
    }
    
    private func configNavigationBar() {
        setupCustomBackButton()
    }
    
    // MARK: - Layout methods
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [nftCollectionView, noNFTLabel].forEach { view.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - FavoritesNFTViewController

extension FavoritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoritesNFT.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoritesNFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let nft = viewModel.favoritesNFT[indexPath.row]
        let viewModel = FavoritesNFTCellViewModel(nft: nft)
        cell.configure(with: viewModel)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - geometricParams.paddingWight) / geometricParams.cellPerRowCount
        return CGSize(width: width, height: geometricParams.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: geometricParams.cellLeftInset, bottom: 0, right: geometricParams.cellRightInset)
    }
}

// MARK: - FavoritesNFTCellDelegateProtocol

extension FavoritesNFTViewController: FavoritesNFTCellDelegateProtocol {
    func didTapHeartButton(in cell: FavoritesNFTCell) {
        guard let indexPath = nftCollectionView.indexPath(for: cell) else { return }
        let nft = viewModel.favoritesNFT[indexPath.row]
        viewModel.dislike(for: nft)
    }
}
