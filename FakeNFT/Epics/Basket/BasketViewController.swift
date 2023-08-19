import UIKit
import ProgressHUD

final class BasketViewController: UIViewController {
    private let basketService = BasketService.shared
    
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
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = "Корзина пуста"
        label.isHidden = true
        label.textColor = .ypBlackUniversal
        return label
    }()
    
    private var sort: Sort? {
        didSet {
            guard let sort else { return }
            basketService.sortingType = sort
            nftsMocked = applySort(nfts: nftsMocked, by: sort)
            nftsTableView.reloadData()
        }
    }
    
    var nftsMocked: [NFTModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nftsMocked = basketService.basket
        print(nftsMocked)
//        OrderService.shared.updateOrder(with: ["92", "91", "93", "94", "95"]) {result in
//            switch result {
//            case .success(_):
//                print("added successfully")
//            case .failure(let error):
//                print(error)
//            }
//        }
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
    
    @objc private func didTapSortButton() {
        let alert = UIAlertController(
            title: nil,
            message: "Сортировка",
            preferredStyle: .actionSheet
        )
        
        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.sort = .price
        }
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.sort = .rating
        }
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.sort = .name
        }
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(sortByPriceAction)
        alert.addAction(sortByRatingAction)
        alert.addAction(sortByNameAction)
        alert.addAction(closeAction)
        
        present(alert, animated: true)
    }
    
    private func setupTableLabel() {
        emptyLabel.isHidden = !nftsMocked.isEmpty
        nftsTableView.isHidden = nftsMocked.isEmpty
        sumView.isHidden = nftsMocked.isEmpty
    }
    
    private func applySort(nfts: [NFTModel], by value: Sort) -> [NFTModel] {
        switch value {
        case .price:
            return nfts.sorted(by: { $0.price < $1.price })
        case .rating:
            return nfts.sorted(by: { $0.rating < $1.rating })
        case .name:
            return nfts.sorted(by: { $0.name < $1.name })
        }
    }
}

private extension BasketViewController {
    func setupView() {
        view.backgroundColor = .white
        sortButton.tintColor = .ypBlackUniversal
        sumView.changeText(totalAmount: nftsMocked.count, totalPrice: nftsMocked.reduce(0.0) { $0 + $1.price })
        
        sumView.delegate = self
        [
            sumView,
            sortButton,
            nftsTableView,
            emptyLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        setupConstraints()
        
        sort = basketService.sortingType
        nftsTableView.reloadData()
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
            nftsTableView.bottomAnchor.constraint(equalTo: sumView.topAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
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
        print("before remove")
        print(basketService.basket)
        basketService.removeNFTFromBasket(model)
        print("after remove")
        print(basketService.basket)
        nftsMocked = basketService.basket
        self.nftsTableView.reloadData()
        sumView.changeText(totalAmount: nftsMocked.count, totalPrice: nftsMocked.reduce(0.0) { $0 + $1.price })
        dismiss(animated: true)
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

enum Sort: Codable, Equatable {
    case price
    case rating
    case name
}
