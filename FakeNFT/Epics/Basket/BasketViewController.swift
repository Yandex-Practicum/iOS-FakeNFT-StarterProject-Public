import UIKit
import ProgressHUD

final class BasketViewController: UIViewController {
    
    private lazy var sortButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "sort")!, target: self, action: #selector(didTapSortButton))
        return button
    }()
    
    private let sumView = SumView()
    
    private lazy var nftsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BasketNFTCell.self)
        return tableView
    }()
    
    var nftsMocked: [NFTModel] = [NFTModel(id: "123",
                                           createdAt: "123",
                                           name: "Spring",
                                           images: ["test"],
                                           rating: 1,
                                           description: "test",
                                           price: 1.78,
                                           author: "test"),
                                  NFTModel(id: "123",
                                           createdAt: "123",
                                           name: "Greena",
                                           images: ["test"],
                                           rating: 3,
                                           description: "test",
                                           price: 3.91,
                                           author: "test")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        ProgressHUD.show()
        // загрузить корзину
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // очистить корзину
    }
    
    @objc
    private func didTapSortButton() {
        // TODO: добавить сортировку
    }
}

private extension BasketViewController {
    
    //    func setupNavBar() {
    //        navigationController?.navigationBar.tintColor = .black
    //        navigationItem.rightBarButtonItem = sortButton
    //    }
    
    func setupView() {
        view.backgroundColor = .white
        sortButton.tintColor = .ypBlackUniversal

        sumView.delegate = self
        
        [sumView,
         sortButton,
         nftsTableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        //        setupNavBar()
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -17),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            sumView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sumView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            sumView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sumView.heightAnchor.constraint(equalToConstant: 76),
            
            nftsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nftsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 54),
            nftsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            nftsTableView.bottomAnchor.constraint(equalTo: sumView.topAnchor)
        ])
    }
    
}

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nftsMocked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BasketNFTCell = tableView.dequeueReusableCell(indexPath: indexPath)
        let model = nftsMocked[indexPath.row]
        cell.delegate = self
        cell.configure(with: model)
        
        return cell
    }
    
}

extension BasketViewController: BasketNFTCellDelegate {
    func didTapRemoveButton(on nft: NFTModel) {
        let removeNFTViewController = RemoveNFTViewController()
        removeNFTViewController.delegate = self
        removeNFTViewController.configure(with: nft)
        removeNFTViewController.modalPresentationStyle = .overFullScreen
        removeNFTViewController.modalTransitionStyle = .crossDissolve
        present(removeNFTViewController, animated: true)
    }
}

extension BasketViewController: RemoveNFTViewControllerDelegate {
    func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    func didTapConfirmButton(_ model: NFTModel) {
    }
}

extension BasketViewController: SumViewDelegate {
    func didTapPayButton() {
        let checkoutViewController = CheckoutViewController()
        let navigationController = UINavigationController(rootViewController: checkoutViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
