import Foundation

final class NFTCollectionPresenter {
    // MARK: - Dependencies
    private weak var view: NFTCollectionViewInput?
    private let nftService: NftListService
    private let favoriteService: FavoriteNftService
    private let orderService: OrderNftService
    private let router: NFTCollectionRouter
    private let nftIds: [String]
    
    // MARK: - State
    private var nfts: [Nft] = []
    private var favorites: [String] = []
    private var itemsInCart: [String] = []
    
    // MARK: - Init
    init(
        view: NFTCollectionViewInput,
        nftService: NftListService,
        favoriteService: FavoriteNftService,
        orderService: OrderNftService,
        router: NFTCollectionRouter,
        nftIds: [String]
    ) {
        self.view = view
        self.nftService = nftService
        self.favoriteService = favoriteService
        self.orderService = orderService
        self.router = router
        self.nftIds = nftIds
    }
}

// MARK: - NFTCollectionViewOutput
extension NFTCollectionPresenter: NFTCollectionViewOutput {
    func viewDidLoad() {
        loadData()
        loadFavorites()
        loadCart()
    }
    
    func didTapBack() {
        router.close()
    }
    
    func didSelectNft(with id: String) {
        router.showNftDetail(id: id)
    }
    
    func didToggleFavorite(for id: String) {
        favoriteService.toggleFavorite(id: id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let favorites):
                    self.favorites = favorites
                    self.view?.updateFavorites(favorites)
                case .failure(let error):
                    self.view?.showError(error)
                }
            }
        }
    }
    
    func didToggleCart(for id: String) {
        orderService.toggleInCart(id: id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let cart):
                    self.itemsInCart = cart
                    self.view?.updateCart(cart)
                case .failure(let error):
                    self.view?.showError(error)
                }
            }
        }
    }
}

// MARK: - Private
private extension NFTCollectionPresenter {
    func loadData() {
        view?.showLoading(true)
        nftService.loadNfts(ids: nftIds) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.view?.showLoading(false)
                switch result {
                case .success(let nfts):
                    self.nfts = nfts
                    self.view?.updateNfts(nfts)
                case .failure(let error):
                    self.view?.showError(error)
                }
            }
        }
    }
    
    func loadFavorites() {
        favoriteService.getFavorites { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let favorites):
                    self.favorites = favorites
                    self.view?.updateFavorites(favorites)
                case .failure(let error):
                    self.view?.showError(error)
                }
            }
        }
    }
    
    func loadCart() {
        orderService.getCart { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let cart):
                    self.itemsInCart = cart
                    self.view?.updateCart(cart)
                case .failure(let error):
                    self.view?.showError(error)
                }
            }
        }
    }
}
