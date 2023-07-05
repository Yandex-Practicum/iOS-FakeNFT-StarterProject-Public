import UIKit

final class MyNFTViewController: UIViewController {
    
    // MARK: - Properties
    var nftIDs: [String]?
    
    private var viewModel: MyNFTViewModel?
    
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
        guard let nftIDs = nftIDs else { return }
        viewModel = MyNFTViewModel(viewController: self, nftIDs: nftIDs)
        bind()
        setupView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    init(nftIDs: [String]) {
        self.nftIDs = nftIDs
        super.init(nibName: nil, bundle: nil)
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
                guard let view = self?.view as? MyNFTView,
                      let nfts = viewModel.myNFTs else { return }
                view.updateNFT(nfts: nfts)
            }
        }
    }
    
    func getAuthorById(id: String) -> String {
        return viewModel?.authors[id] ?? ""
    }
    
    @objc
    private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapSortButton() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Layout methods
    func setupView() {
        guard let nftIDs = nftIDs else { return }
        if nftIDs.isEmpty {
            view.backgroundColor = .white
            setupNavBar(emptyNFTs: true)
            addEmptyLabel()
            UIBlockingProgressHUD.dismiss()
        } else {
            self.view = MyNFTView(frame: .zero, viewController: self)
            setupNavBar(emptyNFTs: false)
        }
    }
    
    func setupNavBar(emptyNFTs: Bool) {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
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

extension MyNFTViewController: UIGestureRecognizerDelegate {}
