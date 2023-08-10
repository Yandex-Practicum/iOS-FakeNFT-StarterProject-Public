import UIKit

final class FavoritesViewController: UIViewController, UIGestureRecognizerDelegate {
    private let likedIDs: [String]
    private var viewModel: FavoritesViewModelProtocol
    
    private var badConnection: Bool = false
    
    private lazy var backButton = UIBarButtonItem(
        image: UIImage.Icons.back,
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )
    
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
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    init(likedIDs: [String]) {
        self.likedIDs = likedIDs
        self.viewModel = FavoritesViewModel(likedIDs: likedIDs)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if badConnection { viewModel.getLikedNFTs(likedIDs: likedIDs) }
    }
    
    private func bind() {
        viewModel.onChange = { [weak self] in
            self?.badConnection = false
            guard let view = self?.view as? FavoritesView,
                  let nfts = self?.viewModel.likedNFTs else { return }
            view.updateNFT(nfts: nfts)
        }
        
        viewModel.onError = { [weak self] error in
            self?.badConnection = true
            let alert = UIAlertController(
                title: "Нет интернета",
                message: error.localizedDescription,
                preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            self?.present(alert, animated: true)
        }
    }
    
    @objc
    private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        if likedIDs.isEmpty {
            view.backgroundColor = .white
            setupNavBar(emptyNFTs: true)
            setupEmptyLabel()
        } else {
            self.view = FavoritesView(frame: .zero, viewModel: self.viewModel)
            setupNavBar(emptyNFTs: false)
        }
    }
    
    private func setupNavBar(emptyNFTs: Bool) {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        backButton.accessibilityIdentifier = "backButton"
        if !emptyNFTs {
            navigationItem.title = "Избранные NFT"
        }
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
