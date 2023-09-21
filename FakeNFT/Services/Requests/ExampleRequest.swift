import Foundation

struct ExampleRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/:endpoint")
    }
}
