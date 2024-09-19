import UIKit
import ProgressHUD

protocol BasketView: AnyObject {
    func updateNfts(_ nfts: [NftModel])
    func showEmptyLabel(_ show: Bool)
    func changeSumText(totalAmount: Int, totalPrice: Float)
    func showHud()
    func removeHud()
}

final class BasketViewController: UIViewController, BasketView {
    private var nfts: [NftModel] = [.init(createdAt: "1344", name: "April", images: [], rating: 1, description: "da", price: 1.78, author: "", id: "1"), .init(createdAt: "1366", name: "Greena", images: [], rating: 4, description: "", price: 3.44, author: "", id: "2"), .init(createdAt: "1211", name: "Qwerty", images: [], rating: 5, description: "11", price: 1, author: "", id: "3")]
    private let sortService = SortService.shared
    private let servicesAssembly: ServicesAssembly
    
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
        label.textColor = .yaBlackLight
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showHud()
        loadOrder()
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
                self?.sortNfts(by: sortValue)
            }
            alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        present(alert, animated: true)
    }
    
    func showHud() {
//        ProgressHUD.show()
    }
    
    func removeHud() {
//        ProgressHUD.dismiss()
    }
    
    func updateNfts(_ nfts: [NftModel]) {
        self.nfts = nfts
        nftsTableView.reloadData()
    }
    
    func showEmptyLabel(_ show: Bool) {
        emptyLabel.isHidden = !show
        nftsTableView.isHidden = show
        sortButton.isHidden = show
        sumView.isHidden = show
    }
    
    func changeSumText(totalAmount: Int, totalPrice: Float) {
        sumView.changeText(totalAmount: totalAmount, totalPrice: totalPrice)
    }
    

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension BasketViewController {
    func setupView() {
        view.backgroundColor = .white
        sortButton.tintColor = .closeButton
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
        sumView.isHidden = true
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
        let cell: BasketNFTCell = tableView.dequeueReusableCell()
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
        removeNFTFromBasket(model)
        dismiss(animated: true)
    }
}

extension BasketViewController: SumViewDelegate {
    func didTapPayButton() {
        // to do: pay button clicked - action
    }
}

extension BasketViewController {
    func loadOrder() {
        // to do: load order
        let currentSortType = sortService.sortingType
        sortNfts(by: currentSortType)
        
        let totalAmount = nfts.count
        let totalPrice = nfts.reduce(0.0) { $0 + $1.price }
        
        updateNfts(nfts)
        changeSumText(totalAmount: totalAmount, totalPrice: totalPrice)
        showEmptyLabel(nfts.isEmpty)
    }
    
    func sortNfts(by value: Sort) {
        sortService.sortingType = value
        let sortedNfts = applySort(nfts: nfts, by: value)
        nfts = sortedNfts
        updateNfts(nfts)
    }
    
    func removeNFTFromBasket(_ model: NftModel) {
        nfts.removeAll(where: { $0.id == model.id })
        loadOrder()
        DispatchQueue.main.async { [weak self] in
            self?.nftsTableView.reloadData()
        }
    }
    
    private func applySort(nfts: [NftModel], by value: Sort) -> [NftModel] {
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
