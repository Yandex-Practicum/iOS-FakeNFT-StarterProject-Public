import Foundation

final class ServicesAssembly: ObservableObject {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient = DefaultNetworkClient(),
        nftStorage: NftStorage = NftStorageImpl()
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
    
    var usersService: UsersService {
        UsersServiceImpl(networkClient: networkClient)
    }
    
    var nftInfoService: NftInfoService {
        NftInfoServiceImpl(networkClient: networkClient)
    }
    
    var likesService: LikesService {
        LikesServiceImpl(networkClient: networkClient)
    }
    
    var userOrdersService: UserOrdersService {
        UserOrdersImpl(networkClient: networkClient)
    }
}
