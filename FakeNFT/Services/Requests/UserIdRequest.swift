import Foundation

struct UserIdRequest: NetworkRequest {
    let userId: String
    var endpoint: URL? {
        URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/users/\(userId)")
    }
}
