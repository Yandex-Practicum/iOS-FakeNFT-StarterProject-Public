import UIKit

final class MyNFTViewController: UIViewController {
    
    // MARK: - Properties
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
        viewModel = MyNFTViewModel(viewController: self)
        bind()
        setupView()
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
            self.view = MyNFTView(frame: .zero, viewController: self)
            setupNavBar()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = sortButton
        navigationItem.title = "Мои NFT"
    }
    
    func getAuthorById(id: String) -> String {
        return viewModel?.authors[id] ?? ""
    }
    
    func addEmptyLabel() {
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }
}
