import Foundation

struct ExampleRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "INSERT_URL_HERE")
    }
}
