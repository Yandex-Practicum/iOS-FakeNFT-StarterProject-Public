final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let nftNetworkStorage: NftNetworkStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.nftNetworkStorage = NftNetworkStorageImpl()
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var usersService: UsersService {
        UsersServiceImpl(networkClient: networkClient)
    }
    
    var nftNetworkService: NftNetworkService {
        NftNetworkServiceImpl(
            networkClient: networkClient,
            storage: nftNetworkStorage
        )
    }
}
 
