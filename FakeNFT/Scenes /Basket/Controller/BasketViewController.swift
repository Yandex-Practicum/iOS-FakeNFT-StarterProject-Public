import UIKit

final class BasketViewController: UIViewController {
    private var nfts: [NftModel] = [.init(createdAt: "1344", name: "April", images: [], rating: 1, description: "da", price: 1.78, author: "", id: "1"), .init(createdAt: "1366", name: "Zreena", images: [], rating: 4, description: "", price: 3.44, author: "", id: "2"), .init(createdAt: "1211", name: "Qwerty", images: [], rating: 5, description: "11", price: 1, author: "", id: "3")]
    private let sortService = SortService.shared
    private let servicesAssembly: ServicesAssembly
    private var basketView: BasketViewProtocol
    
    override func loadView() {
        basketView = BasketView(frame: UIScreen.main.bounds)
        view = basketView as? BasketView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basketView.setDelegate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadOrder()
    }
    
    @objc func didTapSortButton() {
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
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        self.basketView = BasketView(frame: UIScreen.main.bounds)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadOrder() {
        // to do: load order
        let currentSortType = sortService.sortingType
        sortNfts(by: currentSortType)
        
        let totalAmount = nfts.count
        let totalPrice = nfts.reduce(0.0) { $0 + $1.price }
        
        basketView.updateNfts(nfts)
        basketView.changeSumText(totalAmount: totalAmount, totalPrice: totalPrice)
        basketView.showEmptyLabel(nfts.isEmpty)
    }
    
    private func sortNfts(by value: Sort) {
        sortService.sortingType = value
        let sortedNfts = applySort(nfts: nfts, by: value)
        nfts = sortedNfts
        basketView.updateNfts(nfts)
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
    
    private func removeNFTFromBasket(_ model: NftModel) {
        nfts.removeAll(where: { $0.id == model.id })
        loadOrder()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.basketView.updateNfts(self.nfts)
        }
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
        let checkoutViewController = CheckoutViewController()
        let navigationController = UINavigationController(rootViewController: checkoutViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
