import UIKit

final class StatisticNFTCollectionViewController: UIViewController {
    
    // MARK: - Private Dependencies
    private var statisticNFTViewModel: StatisticNFTCollectionViewModelProtocol
    
    // MARK: - Private Properties
    private var indexPathToUpdateNFTCell: IndexPath?
    
    // MARK: - UI
    private lazy var collectionView: NFTCollectionView = {
        let collectionView = NFTCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var stubLabel: UILabel = {
        let stubLabel = UILabel()
        stubLabel.font = .bodyMediumBold
        stubLabel.textColor = .blackDay
        stubLabel.textAlignment = .center
        stubLabel.text = L10n.Statistic.Profile.UserCollection.stub
        stubLabel.isHidden = true
        return stubLabel
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupUI()
        bind()
        blockUI()
    }
    
    // MARK: - Init
    init(statisticNFTViewModel: StatisticNFTCollectionViewModel) {
        self.statisticNFTViewModel = statisticNFTViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Functions
extension StatisticNFTCollectionViewController {
    
    private func bind() {
        statisticNFTViewModel.nftsObservable.bind { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.unblockUI()
                self.collectionView.reloadData()
                self.showStub()
            }
        }
        
        statisticNFTViewModel.likeStatusDidChangeObservable.bind { [weak self] _ in
            guard let self = self else { return }
            self.resumeMethodOnMainThread(self.changeCellStatus, with: true)
        }
        
        statisticNFTViewModel.cartStatusDidChangeObservable.bind { [weak self] _ in
            guard let self = self else { return }
            self.resumeMethodOnMainThread(self.changeCellStatus, with: false)
        }
    }
    
    private func resumeMethodOnMainThread<T>(_ method: @escaping ((T) -> Void), with argument: T) {
        DispatchQueue.main.async {
            method(argument)
        }
    }
    
    private func changeCellStatus(isLike: Bool) {
        guard let indexPathToUpdateNFTCell = self.indexPathToUpdateNFTCell,
              let cell = self.collectionView.cellForItem(at: indexPathToUpdateNFTCell) as? NFTCollectionCell,
              let nftModel = cell.getNFTModel() else { return }
        let newModel = NFTCell(name: nftModel.name,
                               images: nftModel.images,
                               rating: nftModel.rating,
                               price: nftModel.price,
                               author: nftModel.author,
                               id: nftModel.id,
                               isLiked: isLike ? !nftModel.isLiked : nftModel.isLiked,
                               isAddedToCard: isLike ? nftModel.isAddedToCard : !nftModel.isAddedToCard)
        cell.setupNFTModel(model: newModel)
        self.indexPathToUpdateNFTCell = nil
    }
    
    private func showStub() {
        if statisticNFTViewModel.nftsObservable.wrappedValue.count == 0 {
            stubLabel.isHidden = false
        }
    }
    
    private func setupViews() {
        view.setupView(collectionView)
        view.setupView(stubLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        self.title = L10n.Statistic.Profile.ButtonCollection.title
    }
}

// MARK: - DataSource
extension StatisticNFTCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        statisticNFTViewModel.nftsObservable.wrappedValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let model = statisticNFTViewModel.nftsObservable.wrappedValue[indexPath.row]
        cell.delegate = self
        let NFTCellModel = NFTCell(name: model.name,
                                   images: model.images,
                                   rating: Int(model.rating),
                                   price: model.price,
                                   author: model.author,
                                   id: model.id,
                                   isLiked: model.isLiked,
                                   isAddedToCard: model.isAddedToCard)
        
        cell.setupNFTModel(model: NFTCellModel)
        return cell
    }
}

// MARK: - DelegateFlowLayout
extension StatisticNFTCollectionViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - NFTCollectionCellDelegate
extension StatisticNFTCollectionViewController: NFTCollectionCellDelegate {
    func likeButtonDidTapped(cell: NFTCollectionCell) {
        guard let model = cell.getNFTModel(),
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let modelID = model.id
        
        statisticNFTViewModel.changeNFTFavouriteStatus(isLiked: model.isLiked, id: modelID)
        indexPathToUpdateNFTCell = indexPath
    }
    
    func addToCardButtonDidTapped(cell: NFTCollectionCell) {
        guard let model = cell.getNFTModel(),
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let modelID = model.id
        
        statisticNFTViewModel.changeNFTCartStatus(isAddedToCart: model.isAddedToCard, id: modelID)
        indexPathToUpdateNFTCell = indexPath
    }
}
