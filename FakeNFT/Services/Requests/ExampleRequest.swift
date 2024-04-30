import Foundation

struct ExampleRequest: NetworkRequest {
    var isUrlEncoded: Bool { false }
    var endpoint: URL? {
        URL(string: "INSERT_URL_HERE")
    }
}
