import UIKit
import Combine
import SnapKit

enum UsetListViewControllerInput {
    case viewDidLoad
    case pullToRefresh
    case cellIsTap(for: IndexPath)
    case filterButtonTapped
}

final class UserListViewController: NiblessViewController {
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.contentInset.top = 20
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .ypWhite
        view.isHidden = true
        view.delegate = self
        view.refreshControl = refreshControl
        view.register(UserCell.self)
        return view
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, User> = {
        return .init(collectionView: collectionView) { collectionView, indexPath, item in
            let cell: UserCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configure(with: item)
            return cell
        }
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .ypBlack
        control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return control
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private let errorView = ErrorView()

    // MARK: - Dependencies
    private let viewModel: UserListViewModel
    private let input: PassthroughSubject<UsetListViewControllerInput, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        createTabTabItem()
        bind(to: viewModel)
        input.send(.viewDidLoad)
    }

    // MARK: - @objc methods
    @objc private func filterTap() {
        input.send(.filterButtonTapped)
    }

    @objc private func pullToRefresh() {
        input.send(.pullToRefresh)
    }
}

extension UserListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.item]
        let viewModel = UserCardViewModelImpl(user: user)
        let viewController = UserCardViewController(viewModel: viewModel)

        navigationController?.pushViewController(viewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
    }
}

// MARK: - Data
private extension UserListViewController {
    func bind(to viewModel: UserListViewModel) {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handle(event)
            }
            .store(in: &cancellables)
    }

    func handle(_ event: UserListViewModelOutput) {
        switch event {
        case .loading:
            spinner.startAnimating()

        case .success(let users):
            errorView.isHidden = true
            collectionView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.spinner.stopAnimating()
                self.updateSnapshot(with: users)
                self.collectionView.refreshControl?.endRefreshing()
            }

        case .failure:
            spinner.stopAnimating()
            errorView.isHidden = false

        case .filterViewModel(let filterViewModel):
            showAlert(filterViewModel, style: .actionSheet)

        case .filteredData(let users):
            self.updateSnapshot(with: users)
        }
    }

    func updateSnapshot(with data: [User]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UI
private extension UserListViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            self.createLayoutSection()
        }

        return layout
    }

    func createLayoutSection() -> NSCollectionLayoutSection {
        // Item
        let itemInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        let item = NSCollectionLayoutItem.create(
            withWidth: .fractionalWidth(1.0),
            height: .absolute(88),
            insets: itemInsets
        )

        // Group       
        let group = NSCollectionLayoutGroup.create(
            verticalGroupWithWidth: .fractionalWidth(1.0),
            height: .estimated(88),
            items: [item]
        )

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = itemInsets

        return section
    }

    func createTabTabItem() {
        let image = UIImage.sortButton?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.ypBlack)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(filterTap)
        )
    }

    func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(spinner)
        view.addSubview(errorView)
        view.backgroundColor = .ypWhite
    }

    func addConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        errorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.top.equalToSuperview().inset(20)
        }
    }
}
