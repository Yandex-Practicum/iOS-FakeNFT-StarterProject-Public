final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let cartStorage: CartStorage
    private let currencyStorage: CurrencyStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        cartStorage: CartStorage,
        currencyStorage: CurrencyStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.cartStorage = cartStorage
        self.currencyStorage = currencyStorage
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

    var currencyService: CurrencyService {
        CurrencyServiceImpl(
            networkClient: networkClient,
            storage: currencyStorage
        )
    }
}
