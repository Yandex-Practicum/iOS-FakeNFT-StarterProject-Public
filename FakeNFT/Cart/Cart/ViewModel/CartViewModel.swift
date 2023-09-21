import UIKit

protocol CartViewModelProtocol {
    var nfts: [NFTModel]  { get }
    var isLoading: Bool { get }
    var isCartEmpty: Bool { get }
    var nftInfo: NFTInfo { get }
    var formattedPrice: NumberFormatter { get }
    var nftsObservable: Observable<[NFTModel]> { get }
    var isLoadingObservable: Observable<Bool> { get }
    var isCartEmptyObservable: Observable<Bool> { get }
    var orders: [String] { get }
    func didDeleteNFT(index: Int)
    func observe()
    func sortByPrice()
    func sortByRating()
    func sortByName()
}

final class CartViewModel: CartViewModelProtocol {
    
    @Observable
    private (set) var nfts: [NFTModel] = []
    
    @Observable
    private (set) var isLoading: Bool = true
    
    @Observable
    private (set) var isCartEmpty: Bool = true
    
    var nftInfo: NFTInfo {
        let price = nfts.reduce(0.0) { $0 + $1.price}
        return NFTInfo(count: nfts.count, price: price)
    }
    
    var orders: [String] = [] {
        didSet {
            self.nfts = []
            didLoadNft()
        }
    }
    var nftsObservable: Observable<[NFTModel]> { $nfts }
    
    var isLoadingObservable: Observable<Bool> { $isLoading }
    
    var isCartEmptyObservable: Observable<Bool> { $isCartEmpty }
    
    private let cartLoadService: CartLoadServiceProtocol
    
    init(model: CartLoadServiceProtocol = CartLoadService()) {
        self.cartLoadService = model
        getOrder()
    }
    
    var formattedPrice: NumberFormatter = {
        let formatted = NumberFormatter()
        formatted.locale = Locale(identifier: "ru_RU")
        formatted.numberStyle = .decimal
        return formatted
    }()
    
    func observe() {
        isEmptyCart()
        getOrder()
    }
    
    func getOrder() {
        isLoading = true
        nfts = []
        cartLoadService.fetchOrder { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(order):
                    self.orders = order
                case let .failure(error):
                    self.isLoading = false
                    print(error)
                }
            }
        }
    }
    
    func didLoadNft() {
        isLoading = true
        if orders.isEmpty {
            isCartEmpty = true
            isLoading = false
        } else {
            orders.forEach {
                cartLoadService.fetchNfts(id: $0) { [weak self] result in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case let .success(nfts):
                            self.nfts.append(nfts)
                        case let .failure(error):
                            self.isLoading = false
                            print(error)
                        }
                    }
                }
            }
            isLoading = false
        }
    }
    
    func didDeleteNFT(index: Int) {
        isLoading = true
        nfts.remove(at: index)
        cartLoadService.removeFromCart(id: "1", nfts: nfts.map { $0.id }) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("done")
                case let .failure(error):
                    print(error)
                }
            }
        }
        isLoading = false
    }
    
    func sortByPrice() {
        nfts.sort { $0.price < $1.price }
    }
    
    func sortByRating() {
        nfts.sort { $0.rating > $1.rating }
    }
    
    func sortByName() {
        nfts.sort { $0.name < $1.name }
    }
    
    private func isEmptyCart() {
        if nfts.isEmpty {
            isCartEmpty = true
        } else {
            isCartEmpty = false
        }
    }
}
