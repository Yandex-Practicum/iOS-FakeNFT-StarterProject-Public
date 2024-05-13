final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let orderStorage: OrderStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        orderStorage: OrderStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.orderStorage = orderStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var orderService: OrderService {
        OrderService(
            networkClient: networkClient,
            orderStorage: orderStorage)
    }
}
