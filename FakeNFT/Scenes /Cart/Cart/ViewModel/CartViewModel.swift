import Foundation

class CartViewModel {
    let servicesAssembly: ServicesAssembly
    var isEmpty: Bool {
        nfts.isEmpty
    }
    var onDataErrorResult: (() -> Void)?

    @Observable
    private (set) var nfts: [Nft] = []

    private lazy var cartFilterStorage = CartFilterStorage.shared

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func loadData() {
        servicesAssembly.cartService.loadNFTs { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    self.nfts = nfts
                    self.sort(by: self.cartFilterStorage.cartSortType)
                case .failure:
                    self.onDataErrorResult?()
                }
            }
        }
    }

    func countNftInCart() -> Int {
        nfts.count
    }

    func getNft(at index: Int) -> Nft {
        nfts[index]
    }

    func getTotalPrice() -> String {
        let total = totalPriceCount()
        let formattedTotal = NumberFormatter.priceFormatter.string(from: NSNumber(value: total)) ?? "\(total)"
        return formattedTotal
    }

    func sort(by type: CartSortType) {
        switch type {
        case .price:
            nfts.sort { $0.price < $1.price }
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        case .name:
            nfts.sort { $0.name < $1.name }
        }
        cartFilterStorage.cartSortType = type
    }

    func deleteNftFromCart(at index: Int) {
        nfts.remove(at: index)
        servicesAssembly.cartService.deleteNftFromCart(cartId: "1", nfts: nfts.map { $0.id }) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.loadData()
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }

    private func totalPriceCount() -> Float {
        nfts.reduce(0) { $0 + $1.price }
    }
}
