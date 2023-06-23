import Foundation

struct ExampleRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://648cbbbe8620b8bae7ed5043.mockapi.io")
    }
}
