final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var userService: UserService {
        UserServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var userDefaultsStore: UserDefaultsStore {
        UserDefaultsStore.shared
    }
}
