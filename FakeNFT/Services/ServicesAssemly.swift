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
        NftServiceImpl(client: networkClient)
    }
    
    var nftListService: NftListService {
        NftListNetworkService(networkClient: networkClient)
    }

    var catalogProvider: CatalogProviderProtocol {
        let catalogsService = CatalogsServiceImpl(client: networkClient)
        return CatalogNetworkProvider(service: catalogsService)
    }
    
    var favoriteNftService: FavoriteNftService {
        FavoriteNftNetworkService(networkClient: networkClient)
    }

    var orderNftService: OrderNftService {
        OrderNftNetworkService(networkClient: networkClient)
    }
}
