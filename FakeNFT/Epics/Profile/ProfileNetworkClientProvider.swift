final class ProfileNetworkClientProvider {
    private let networkClient: ProfileNetworkClientProtocol

    init(networkClient: ProfileNetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func getProfileNetworkClient() -> ProfileNetworkClientProtocol {
        return networkClient
    }
}
