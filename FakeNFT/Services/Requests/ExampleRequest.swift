import Foundation

struct ExampleRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL)
    }
}
