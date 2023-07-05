import UIKit

final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    var likedIDs: [String]?
    
    private var viewModel: FavoritesViewModel?
    
    
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
        guard let likedIDs = likedIDs else { return }
        viewModel = FavoritesViewModel(viewController: self, likedIDs: likedIDs)
        bind()
        setupView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    init(likedIDs: [String]) {
        self.likedIDs = likedIDs
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
        if let viewModel = viewModel {
            viewModel.onChange = { [weak self] in
                guard let view = self?.view as? FavoritesView,
                      let nfts = viewModel.likedNFTs else { return }
                view.updateNFT(nfts: nfts)
            }
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
//            UIBlockingProgressHUD.dismiss()
        } else {
            self.view = FavoritesView(frame: .zero, viewController: self)
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
