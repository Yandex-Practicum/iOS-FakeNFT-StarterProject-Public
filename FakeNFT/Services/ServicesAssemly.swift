final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let cartStorage: CartStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        cartStorage: CartStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.cartStorage = cartStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var cartService: CartService {
        CartServiceImpl(
            networkClient: networkClient,
            storage: cartStorage
        )
    }
}
