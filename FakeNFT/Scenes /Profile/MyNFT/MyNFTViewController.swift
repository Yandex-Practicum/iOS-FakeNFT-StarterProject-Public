import UIKit

final class NyNFTViewController: UIViewController, UIGestureRecognizerDelegate {
    private let viewModel: MyNFTViewModelProtocol
    
    private let nftsID: [String]
    private let likedsID: [String]
    private var badConnection: Bool = false
    
    private lazy var emptyLabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет NFT"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .appBlack
        return label
    }()
    
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
    
    init(nftIDs: [String], likedIDs: [String]) {
        self.nftsID = nftIDs
        self.likedsID = likedIDs
        self.viewModel = MyNFTViewModel(nftIDs: nftIDs, likedIDs: likedIDs)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.checkStoredSort()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if badConnection {
            UIBlockingProgressHUD.show()
            viewModel.getMyNFTs(nftIDs: nftsID)
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func bind() {
        viewModel.onChange = { [weak self] in
            self?.badConnection = false
            guard let view = self?.view as? MyNFTView,
                  let nfts = self?.viewModel.myNFTs else { return }
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
    
    @objc
    private func didTapSortButton() {
        let alert = UIAlertController(
            title: nil,
            message: "Сортировка",
            preferredStyle: .actionSheet
        )
                
        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.viewModel.sort = .price
            self?.saveSortOrder(order: .price)
        }
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.viewModel.sort = .rating
            self?.saveSortOrder(order: .rating)
        }
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.viewModel.sort = .name
            self?.saveSortOrder(order: .name)
        }
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(sortByPriceAction)
        alert.addAction(sortByRatingAction)
        alert.addAction(sortByNameAction)
        alert.addAction(closeAction)
        
        present(alert, animated: true)
    }
    
    private func saveSortOrder(order: MyNFTViewModel.Sort) {
        let data = try? PropertyListEncoder().encode(order)
        UserDefaults.standard.set(data, forKey: "sortOrder")
    }
    
    private func setupView() {
        if nftsID.isEmpty {
            view.backgroundColor = .white
            setupNavBar(emptyNFTs: true)
            setupEmptyLabel()
        } else {
            self.view = MyNFTView(frame: .zero, viewModel: self.viewModel)
            setupNavBar(emptyNFTs: false)
        }
    }
    
    private func setupNavBar(emptyNFTs: Bool) {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        backButton.accessibilityIdentifier = "backButton"
        if !emptyNFTs {
            navigationItem.rightBarButtonItem = sortButton
            navigationItem.title = "Мои NFT"
        }
    }
    
    private func setupEmptyLabel() {
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
