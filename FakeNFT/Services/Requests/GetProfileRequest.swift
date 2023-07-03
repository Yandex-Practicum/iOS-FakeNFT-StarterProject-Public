import Foundation

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("profile/1")
    }
}
