import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://648cbbf38620b8bae7ed510b.mockapi.io/api/v1/profile/1")
    }
}
