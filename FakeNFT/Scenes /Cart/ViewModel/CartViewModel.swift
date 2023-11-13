import Foundation

protocol CartViewModelDelegate: AnyObject {
    func getLoadData()
}

class CartViewModel {

    enum SortType: Int {
          case price
          case rating
          case name
      }

    weak var delegate: CartViewModelDelegate?
    let servicesAssembly: ServicesAssembly
    var isEmpty: Bool {
        return nfts.isEmpty
    }
    private let sortTypeKey = "SortTypeKey"
    private var currentSortType: SortType {
        didSet {
            UserDefaults.standard.set(currentSortType.rawValue, forKey: sortTypeKey)
            print("Current sort type set to: \(currentSortType)")
        }
    }

    @Observable
    private (set) var nfts: [Nft] = []

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        self.currentSortType = SortType(rawValue: UserDefaults.standard.integer(forKey: sortTypeKey)) ?? .name
        print("Current sort type set to: \(currentSortType)")
    }

    func loadData() {
        servicesAssembly.cartService.loadNFTs { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = nfts
                self.sort(by: currentSortType)
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
        let total = totalPriceCount()
        let formattedTotal = NumberFormatter.priceFormatter.string(from: NSNumber(value: total)) ?? "\(total)"
        return formattedTotal
    }

    private func sort(by type: SortType) {
        switch type {
        case .price:
            sortByPrice()
        case .rating:
            sortByRating()
        case .name:
            sortByName()
        }
        UserDefaults.standard.set(type.rawValue, forKey: sortTypeKey)
        print("Current sort type after set: \(currentSortType)")
    }

    func sortByPrice() {
        nfts.sort { $0.price < $1.price }
        currentSortType = .price
    }

    func sortByRating() {
        nfts.sort { $0.rating > $1.rating }
        currentSortType = .rating
    }

    func sortByName() {
        nfts.sort { $0.name < $1.name }
        currentSortType = .name
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
