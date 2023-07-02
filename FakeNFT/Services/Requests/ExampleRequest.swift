import Foundation

struct ExampleRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://64a03ffded3c41bdd7a723cb.mockapi.io/api/v1/:endpoint")
    }
}
