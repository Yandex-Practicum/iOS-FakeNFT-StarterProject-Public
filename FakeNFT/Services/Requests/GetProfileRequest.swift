import Foundation

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
        NetworkConstants.baseURL.appendingPathComponent(NetworkConstants.profileEndpoint)
    }
}
