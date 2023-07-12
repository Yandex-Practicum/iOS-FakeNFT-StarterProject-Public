import UIKit

final class MyNFTViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    var nftIDs: [String]
    var likedIDs: [String]
    
    private var viewModel: MyNFTViewModel
    private var badConnection: Bool = false
    
    //MARK: - Layout elements
    private lazy var backButton = UIBarButtonItem(
        image: UIImage.Icons.back,
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )
    
    private lazy var sortButton = UIBarButtonItem(
        image: UIImage.Icons.sort,
        style: .plain,
        target: self,
        action: #selector(didTapSortButton)
    )
    
    private lazy var emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "У Вас ещё нет NFT"
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
    
    init(nftIDs: [String], likedIDs: [String]) {
        self.nftIDs = nftIDs
        self.likedIDs = likedIDs
        self.viewModel = MyNFTViewModel(nftIDs: nftIDs, likedIDs: likedIDs)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if badConnection { viewModel.getMyNFTs(nftIDs: nftIDs) }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - Methods
    private func bind() {
        viewModel.onChange = { [weak self] in
            self?.badConnection = false
            guard let view = self?.view as? MyNFTView,
                  let nfts = self?.viewModel.myNFTs else { return }
            view.updateNFT(nfts: nfts)
        }
        
        viewModel.onError = { [weak self] in
            self?.badConnection = true
            let alert = UIAlertController(
                title: "Нет интернета",
                message: "Что-то не так со связью :(",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
                self?.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            self?.present(alert, animated: true)
        }
    }
    
    func getAuthorById(id: String) -> String {
        return viewModel.authors[id] ?? ""
    }
    
    @objc
    private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapSortButton() {
        let alert = UIAlertController(
            title: nil,
            message: "Сортировка",
            preferredStyle: .actionSheet
        )
        
        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.viewModel.sort = .price
        }
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.viewModel.sort = .rating
        }
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.viewModel.sort = .name
        }
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(sortByPriceAction)
        alert.addAction(sortByRatingAction)
        alert.addAction(sortByNameAction)
        alert.addAction(closeAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Layout methods
    func setupView() {
        if nftIDs.isEmpty {
            view.backgroundColor = .white
            setupNavBar(emptyNFTs: true)
            addEmptyLabel()
        } else {
            self.view = MyNFTView(frame: .zero, viewModel: self.viewModel)
            setupNavBar(emptyNFTs: false)
        }
    }
    
    func setupNavBar(emptyNFTs: Bool) {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        backButton.accessibilityIdentifier = "backButton"
        if !emptyNFTs {
            navigationItem.rightBarButtonItem = sortButton
            navigationItem.title = "Мои NFT"
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
