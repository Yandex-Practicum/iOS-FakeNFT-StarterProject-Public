final class ServicesAssembler {

  static let shared = ServicesAssembler(
    networkClient: DefaultNetworkClient(),
    nftStorage: NftStorageImpl()
  )

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
}
