import UIKit

final class FavoritesViewController: UIViewController, UIGestureRecognizerDelegate {
    private let viewModel: FavoritesViewModelProtocol
    
    private lazy var favoriteNFTCollection: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FavoritesCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "У Вас ещё нет избранных NFT"
        emptyLabel.font = UIFont.boldSystemFont(ofSize: 17)
        emptyLabel.textColor = .black
        return emptyLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupView()
        setupConstraints()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        view.backgroundColor = .white
    }
    
    init(viewModel: FavoritesViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.onChange = { [weak self] in
            guard let self = self else { return }
            self.favoriteNFTCollection.reloadData()
            favoriteNFTCollection.isHidden = viewModel.checkNoNFT()
            emptyLabel.isHidden = !viewModel.checkNoNFT()
            navigationItem.title = viewModel.setTitle()
        }
        
        viewModel.onError = { [weak self] error in
            guard let self = self else { return }
            let errorAlert = AlertModel(
                title: "Нет интернета",
                message: error.localizedDescription,
                textField: false,
                placeholder: "",
                buttonText: "Ok",
                styleAction: .cancel) { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }
            let alert = self.viewModel.showAlert(errorAlert)
            self.present(alert, animated: true)
        }
    }
    
    @objc
    private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        setupEmptyLabel()
        view.backgroundColor = .white
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupConstraints() {
        view.addSubview(favoriteNFTCollection)
        
        NSLayoutConstraint.activate([
            favoriteNFTCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteNFTCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            favoriteNFTCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteNFTCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let likedNFTs = viewModel.likedNFTs else { return 0 }
        return likedNFTs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoritesCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.backgroundColor = .white
        guard let likedNFTs = viewModel.likedNFTs,
              !likedNFTs.isEmpty else { return FavoritesCell() }
        let likedNFT = likedNFTs[indexPath.row]
        
        let model = FavoritesCell.Model(
            image: likedNFT.images.first ?? "",
            name: likedNFT.name,
            rating: likedNFT.rating,
            price: likedNFT.price,
            isFavorite: true,
            id: likedNFT.id
        )
        cell.tapAction = { [unowned viewModel] in
            viewModel.favoriteUnliked(id: likedNFT.id)
        }
        cell.configureCell(with: model)
        
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 16 * 2 - 7
        return CGSize(width: availableWidth / 2, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
}
