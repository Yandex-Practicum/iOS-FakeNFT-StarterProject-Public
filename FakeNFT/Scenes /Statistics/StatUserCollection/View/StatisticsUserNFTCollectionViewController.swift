import UIKit

final class StatisticsUserNFTCollectionViewController:
    UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {

    let userCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private let geometricParams = GeometricParams(cellCount: 3, leftInset: 16, rightInset: 16, cellSpacing: CGSize(width: 9, height: 28))

    private let viewModel: StatisticsUserNFTCollectionViewModel

    init(viewModel: StatisticsUserNFTCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.$nfts.bind(executeInitially: true) { [weak self] _ in
            self?.userCollection.reloadData()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        userCollection.delegate = self
        userCollection.dataSource = self
        userCollection.register(StatisticsUserNFTCollectionViewCell.self)

        configureNavigationBar()
        setupConstraints()

        viewModel.loadData()
    }

    func setLoaderIsHidden(_ isHidden: Bool) {
        if isHidden {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }

    private func configureNavigationBar() {
        let backImage = UIImage(systemName: "chevron.backward")?
            .withTintColor(.ypBlack ?? .black)
            .withRenderingMode(.alwaysOriginal)
        navigationItem.title = "nftCollection"

        if self !== navigationController?.viewControllers.first {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: backImage,
                style: .plain,
                target: self,
                action: #selector(backTapped)
            )
        }
    }

    private func setupConstraints() {
        view.addSubview(activityIndicator)
        activityIndicator.layer.zPosition = 9999
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(userCollection)
        userCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            userCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            userCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Actions

    @objc
    private func backTapped() {
        viewModel.didTapBack()
    }
}

// MARK: - UICollectionViewDataSource
extension StatisticsUserNFTCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.nfts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StatisticsUserNFTCollectionViewCell = userCollection.dequeueReusableCell(indexPath: indexPath)
        cell.configure(with: viewModel.nfts[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StatisticsUserNFTCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - geometricParams.paddingWidth
        let cellWidth = floor(availableWidth / CGFloat(geometricParams.cellCount))
        let cellHeight = StatisticsUserNFTCollectionViewCell.heightForWidth(cellWidth)
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: geometricParams.leftInset, bottom: 10, right: geometricParams.rightInset)
    }

    func collectionView(_: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return geometricParams.cellSpacing.height
    }

    func collectionView(_: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return geometricParams.cellSpacing.width
    }
}
