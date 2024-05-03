final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let usersStorage: UsersStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        usersStorage: UsersStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.usersStorage = usersStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var statisticsService: UsersServiceProtocol {
        UsersService(
            networkClient: networkClient,
            storage: usersStorage
        )
    }
}
