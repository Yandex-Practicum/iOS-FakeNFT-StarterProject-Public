final class ServicesAssembler {

  static let shared = ServicesAssembler(
    networkClient: DefaultNetworkClient()
  )

  private let networkClient: NetworkClient

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  var nftService: NftService {
    NftServiceImpl(networkClient: networkClient)
  }
}
