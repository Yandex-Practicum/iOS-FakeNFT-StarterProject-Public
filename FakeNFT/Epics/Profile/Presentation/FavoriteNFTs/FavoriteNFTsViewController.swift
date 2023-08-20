import UIKit

final class FavoriteNFTsViewController: UIViewController & NFTsViewControllerProtocol {
    // MARK: - Public properties
    
    var presenter: FavoriteNFTsViewDelegate?
    
    // MARK: - Private properties
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collection.dataSource = self
        collection.delegate = self
        collection.register(FavoriteNFTCell.self, forCellWithReuseIdentifier: FavoriteNFTCell.identifier)
        collection.backgroundColor = .clear
        collection.isScrollEnabled = true
        return collection
    }()
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = NSLocalizedString("nft.missing", comment: "")
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    private let collectionParameters = FeaturedCollectionParameters(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 7
    )
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        presenter?.viewDidLoad()
        configureNavigationController()
        addingUIElements()
        layoutConfigure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.callback?()
    }
    
    // MARK: - NFTsViewControllerProtocol
    
    func updateTableOrCollection() {
        checkPlaceholderLabelVisibility()
        collectionView.reloadData()
    }
    
    func showNetworkErrorAlert(with error: Error) {
        if presentedViewController is UIAlertController { return }
        
        let alertMessage = ("\(NSLocalizedString("nft.error.message", comment: ""))\n\(error)")
        
        let alert = UIAlertController(
            title: NSLocalizedString("nft.error.title", comment: ""),
            message: alertMessage,
            preferredStyle: .alert)
        
        let repeatAction = UIAlertAction(
            title: NSLocalizedString("profile.photo.retryButton", comment: ""),
            style: .default
        ) { _ in
            self.presenter?.viewDidLoad()
        }
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("profile.photo.cancelButton", comment: ""),
            style: .cancel
        )
        alert.addAction(repeatAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    
    // MARK: - Private methods
    
    private func addingUIElements() {
        [placeholderLabel, collectionView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionParameters.leftInset),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionParameters.rightInset),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureNavigationController() {
        title = NSLocalizedString("profile.featured", comment: "")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.bodyBold,
            .foregroundColor: UIColor.ypBlack
        ]
        
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .semibold)
        
        let backImage = UIImage(
            systemName: "chevron.left",
            withConfiguration: symbolConfiguration
        ) ?? UIImage()
        
        let backButton = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func checkPlaceholderLabelVisibility() {
        placeholderLabel.isHidden = presenter?.placeholderLabelIsNeedToHide ?? true
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension FavoriteNFTsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = view.frame.size.width - collectionParameters.paddingWidth
        let cellWidth = availableWidth / CGFloat(collectionParameters.cellCount)
        return CGSize(width: cellWidth, height: 100)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return collectionParameters.cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}


// MARK: - UICollectionViewDataSource

extension FavoriteNFTsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.counterOfNFTs ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let presenter = presenter,
            indexPath.row < presenter.counterOfNFTs
        else { return UICollectionViewCell() }
        
        let cell: FavoriteNFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let model = presenter.getModelFor(indexPath: indexPath)
        cell.delegate = self
        cell.configureCell(with: model, indexPath: indexPath)
        return cell
    }
}


// MARK: - FavoriteNFTCellDelegate

extension FavoriteNFTsViewController: FavoriteNFTCellDelegate {
    func didTapLikeButton(at indexPath: IndexPath) {
        presenter?.deleteNFT(at: indexPath)
        checkPlaceholderLabelVisibility()
    }
}
