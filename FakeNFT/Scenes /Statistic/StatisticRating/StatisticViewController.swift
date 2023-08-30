import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - Private Dependencies
    private var alertService: AlertServiceProtocol?
    private var statisticViewModel: StatisticViewModelProtocol
    private lazy var refreshControl = UIRefreshControl()
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StatisticCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupUI()
        setupNavBar()
        blockUI()
        bind()
    }
    
    // MARK: - Init
    init(statisticViewModel: StatisticViewModelProtocol) {
        self.statisticViewModel = statisticViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource
extension StatisticViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        statisticViewModel.usersRatingObservable.wrappedValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StatisticCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        
        cell.setupNumberLabelText(text: String(indexPath.row + 1))
        cell.setupCellUI(model: statisticViewModel.usersRatingObservable.wrappedValue[indexPath.row])
        return cell
    }
}

// MARK: - DelegateFlowLayout
extension StatisticViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let statisticUserViewModel = StatisticUserViewModel(
            profile: statisticViewModel.usersRatingObservable.wrappedValue[indexPath.row])
        
        let statisticUserViewController = StatisticUserViewController(statisticUserViewModel: statisticUserViewModel)
        navigationController?.pushViewController(statisticUserViewController, animated: true)
    }
}

extension StatisticViewController {
    
    // MARK: - Objc Methods:
    @objc
    private func didTapSortButton() {
        showActionSheet()
    }
    
    @objc private func refreshNFTCatalog() {
        blockUI()
        statisticViewModel.fetchUsersRating()
    }
    
    // MARK: - Private Functions
    private func showActionSheet() {
        alertService = UniversalAlertService()
        alertService?.showActionSheet(title: L10n.Sorting.title, sortingOptions: [.byName, .byRating, .close], on: self) { selectedOptions in
            self.performSorting(selectedOptions)
        }
    }
    
    private func performSorting(_ selectedOptions: SortingOption) {
        switch selectedOptions {
        case .byName:
            statisticViewModel.sortUsers(by: .byName, usersList: statisticViewModel.usersRatingObservable.wrappedValue)
        case .byRating:
            statisticViewModel.sortUsers(by: .byRating, usersList: statisticViewModel.usersRatingObservable.wrappedValue)
        default:
            break
        }
        alertService = nil
    }
    
    private func bind() {
        statisticViewModel.usersRatingObservable.bind { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.unblockUI()
                self.collectionView.reloadData()
            }
        }
        
        statisticViewModel.networkErrorObservable.bind { [weak self] errorText in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if errorText == nil {
                    self.refreshControl.endRefreshing()
                    self.unblockUI()
                } else {
                    self.refreshControl.endRefreshing()
                    self.unblockUI()
                    self.showNotificationBanner(with: errorText ?? "")
                }
            }
        }
    }
    
    private func setupViews() {
        view.setupView(collectionView)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshNFTCatalog), for: .valueChanged)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .whiteDay
    }
    
    private func setupNavBar() {
        let sortButton = SortNavBarBaseButton()
        sortButton.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
    }
}
