import Foundation

struct UserRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://64c516f8c853c26efada7af9.mockapi.io/api/v1/users")
    }
}
