final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let tokenStorage: TokenStorage
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        tokenStorage: TokenStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.tokenStorage = tokenStorage
    }
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient, tokenStorage: tokenStorage)
    }
}
