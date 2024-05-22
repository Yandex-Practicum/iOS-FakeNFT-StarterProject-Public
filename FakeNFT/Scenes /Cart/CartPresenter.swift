import UIKit

protocol CartPresenterProtocol {
    var visibleNft: [Nft] { get set }
    var view: CartViewControllerProtocol? { get set }
    var sortType: SortType { get set }
    var priceCart: Double? { get set }
    func editOrder(typeOfEdit: EditType, nftId: String, completion: @escaping (Error?) -> Void)
    func sortCatalog()
    func getAllCartData()
    func cleanCart()
}

enum SortType {
    case none
    case byName
    case byPrice
    case byRating
}

enum EditType {
    case addNft
    case deleteNft
}

final class CartPresenter: CartPresenterProtocol {

    weak var view: CartViewControllerProtocol?

    var sortType: SortType = {
        let type = UserDefaults.standard.string(forKey: "CartSorted")
        switch type {
        case "byName":
            return .byName
        case "byPrice":
            return .byPrice
        case "byRating":
            return .byRating
        default:
            return .none
        }
    }()
    var cart: Cart?
    var visibleNft: [Nft] = []
    var priceCart: Double?

    private let cartNetwork: CartNetwork
    private let baseNetwork: DefaultNetworkClient

    init() {
        self.cartNetwork = CartNetwork()
        self.baseNetwork = DefaultNetworkClient()
    }

    func getAllCartData() {
        view?.startLoading()
        cart = nil
        visibleNft = []
        view?.updateTable()
        priceCart = 0
        cartNetwork.getCart { [weak self] cartItem in
            guard let self = self, let cartItem = cartItem else { return }
            self.saveCart(cart: cartItem)
            if cartItem.nfts.isEmpty && cartItem.nfts.count == 0 {
                view?.showEmptyMessage()
                self.view?.stopLoading()
                return
            } else {
                view?.hideEmptyMessage()
            }
            self.getNftsCart(cart: cartItem.nfts) {
                DispatchQueue.main.async {
                    self.view?.updateNftsCount()
                    self.sortCatalog()
                    self.view?.updateTable()
                }
                self.view?.stopLoading()
            }
        }
    }

    func editOrder(typeOfEdit: EditType, nftId: String, completion: @escaping (Error?) -> Void) {
        cartNetwork.getCart { [weak self] cartItem in
            guard let self = self, let cartItem = cartItem else { return }
            var items = cartItem.nfts
            if typeOfEdit == .addNft {
                items.append(nftId)
            } else {
                if let index = items.firstIndex(of: nftId) {
                    items.remove(at: index)
                } else {
                    return
                }
            }
            cartNetwork.sendNewOrder(nftsIds: items) { _ in
                self.getAllCartData()
            }
        }
    }

    func cleanCart() {
        cartNetwork.sendNewOrder(nftsIds: []) { _ in
            self.getAllCartData()
        }
    }

    private func getNftsCart(cart: [String], completion: @escaping () -> Void) {
        let group = DispatchGroup()
        cart.forEach {
            group.enter()
            self.baseNetwork.send(request: CartGetNftsRequest(nftId: $0), type: Nft.self) { [weak self] result in
                defer {
                    group.leave()
                }
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    priceCart = (priceCart ?? 0) + nft.price
                    self.visibleNft.append(nft)
                case .failure(let error):
                    print("Error fetching NFT collection: \(error)")
                }
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }

    func sortCatalog() {
        sortType = {
            let type = UserDefaults.standard.string(forKey: "CartSorted")
            switch type {
            case "byName":
                return .byName
            case "byPrice":
                return .byPrice
            case "byRating":
                return .byRating
            default:
                return .byName
            }
        }()

        switch sortType {
        case .none:
            break
        case .byName:
            visibleNft.sort { $0.name < $1.name }
            view?.updateTable()
        case .byPrice:
            visibleNft.sort { $0.price > $1.price }
            view?.updateTable()
        case .byRating:
            visibleNft.sort { $0.rating > $1.rating }
            view?.updateTable()
        }
    }

    private func saveCart(cart: Cart) {
        self.cart = cart
    }
}
