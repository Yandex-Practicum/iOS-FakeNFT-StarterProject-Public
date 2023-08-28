import UIKit

protocol BasketView: AnyObject {
    func updateNfts(_ nfts: [NftModel])
    func showEmptyLabel(_ show: Bool)
    func changeSumText(totalAmount: Int, totalPrice: Float)
    func showHud()
    func removeHud()
}

final class BasketViewController: UIViewController, BasketView {
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sumView: SumView = {
        let sum = SumView()
        sum.delegate = self
        return sum
    }()
    
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
    
    private var presenter: BasketPresenter?
    private var nfts: [NftModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = BasketPresenter(view: self)

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showHud()
        presenter?.loadOrder()
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
        
        let sorts: [(String, Sort)] = [("По цене", .price), ("По рейтингу", .rating), ("По названию", .name)]
        sorts.forEach { title, sortValue in
            let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.presenter?.sortNfts(by: sortValue)
            }
            alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        present(alert, animated: true)
    }
    
    func showHud() {
        UIBlockingProgressHUD.show()
    }
    
    func removeHud() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func updateNfts(_ nfts: [NftModel]) {
        self.nfts = nfts
        nftsTableView.reloadData()
    }
    
    func showEmptyLabel(_ show: Bool) {
        emptyLabel.isHidden = !show
        nftsTableView.isHidden = show
        sumView.isHidden = show
    }
    
    func changeSumText(totalAmount: Int, totalPrice: Float) {
        sumView.changeText(totalAmount: totalAmount, totalPrice: totalPrice)
    }
}

private extension BasketViewController {
    func setupView() {
        view.backgroundColor = .white
        sortButton.tintColor = .ypBlackUniversal
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
        nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BasketNFTCell = tableView.dequeueReusableCell(indexPath: indexPath)
        let model = nfts[indexPath.row]
        cell.delegate = self
        cell.configure(with: model)
        
        return cell
    }
}

extension BasketViewController: BasketNFTCellDelegate {
    func didTapRemoveButton(on nft: NftModel) {
        let removeNFTViewController = RemoveNFTViewController(nftModel: nft, delegate: self)
        removeNFTViewController.modalPresentationStyle = .overFullScreen
        removeNFTViewController.modalTransitionStyle = .crossDissolve
        present(removeNFTViewController, animated: true)
    }
}

extension BasketViewController: RemoveNFTViewControllerDelegate {
    func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    func didTapConfirmButton(_ model: NftModel) {
        presenter?.removeNFTFromBasket(model)
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
