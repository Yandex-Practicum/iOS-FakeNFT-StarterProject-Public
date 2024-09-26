import UIKit

final class BasketViewController: UIViewController {
    private var nfts: [NftModel] = []
    private let sortService = SortService.shared
    private let servicesAssembly: ServicesAssembly
    private var basketView: BasketViewProtocol
    private let orderService = OrderService.shared
    private let basketService = BasketService.shared
    
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
        basketView.showHud()
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
        orderService.getNFTModels { nfts in
            if let nfts = nfts {
                self.basketService.basket = nfts
            } else {
                print("Error with handling nfts")
                self.basketService.basket = []
            }
            
//            self.basketService.basket = [.init(createdAt: "s231", name: "sda", images: [], rating: 1, description: "sad", price: 1.2, author: "sa", id: "1")]
//            self.nfts = self.basketService.basket
            self.loadBasket()
            self.basketView.removeHud()
        }
    }
    
    private func loadBasket() {
        nfts = basketService.basket
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
        basketService.removeNFTFromBasket(model)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.basketView.updateNfts(self.nfts)
        }
        loadBasket()
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
