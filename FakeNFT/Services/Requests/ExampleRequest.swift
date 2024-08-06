import Foundation

struct ExampleRequest: NetworkRequest {
    var token: String?

    var endpoint: URL? {
        URL(string: "INSERT_URL_HERE")
    }
}
