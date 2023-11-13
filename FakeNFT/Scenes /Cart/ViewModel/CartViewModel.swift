import Foundation

protocol CartViewModelDelegate: AnyObject {
    func getLoadData()
}

class CartViewModel {
    weak var delegate: CartViewModelDelegate?
    let servicesAssembly: ServicesAssembly
    var isEmpty: Bool {
            return nfts.isEmpty
        }

    @Observable
    private (set) var nfts: [Nft] = []

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func loadData() {
        servicesAssembly.cartService.loadNFTs { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = nfts
                self.delegate?.getLoadData()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }

    func countNftInCart() -> Int {
        return nfts.count
    }

    func getNft(at index: Int) -> Nft {
        return nfts[index]
    }

    func getTotalPrice() -> String {
        return "\(totalPriceCount())"
    }

    private func totalPriceCount() -> Float {
        return nfts.reduce(0) { $0 + $1.price }
    }

    private func observeChanges() {
        $nfts.bind { [weak self] _ in
            self?.delegate?.getLoadData()
        }
    }
}
