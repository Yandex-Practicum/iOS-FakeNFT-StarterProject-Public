import UIKit

final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    var likedIDs: [String]?
    
    private var viewModel: FavoritesViewModel
    
    
    //MARK: - Layout elements
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
    
    // MARK: - Lifecycle
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
        //        UIBlockingProgressHUD.show()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - Methods
    private func bind() {
        viewModel.onChange = { [weak self] in
            guard let view = self?.view as? FavoritesView,
                  let nfts = self?.viewModel.likedNFTs else { return }
            view.updateNFT(nfts: nfts)
        }
        
        viewModel.onError = { [weak self] in
            let alert = UIAlertController(
                title: "Нет интернета",
                message: "Пропал интернет :(",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
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
    
    // MARK: - Layout methods
    func setupView() {
        guard let likedIDs = likedIDs else { return }
        if likedIDs.isEmpty {
            view.backgroundColor = .white
            setupNavBar(emptyNFTs: true)
            addEmptyLabel()
            UIBlockingProgressHUD.dismiss()
        } else {
            self.view = FavoritesView(frame: .zero, viewModel: self.viewModel)
            setupNavBar(emptyNFTs: false)
        }
    }
    
    func setupNavBar(emptyNFTs: Bool) {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        if !emptyNFTs {
            navigationItem.title = "Избранные NFT"
        }
    }
    
    func addEmptyLabel() {
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
}

extension FavoritesViewController: UIGestureRecognizerDelegate {}
