import Foundation

enum NetworkRequests: NetworkRequest {
    case profile
    case order
    case example
    case nft
    case userId(userId: String)
    case collection
    
    var endpoint: URL? {
        switch self {
        case .profile:
            return URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/profile/1")
        case .order:
            return URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/orders/1")
        case .example:
            return URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/:endpoint")
        case .nft:
            return URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/nft")
        case .userId(userId: let userId):
            return URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/users/\(userId)")
        case .collection:
            return URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/collections")
        }
    }
}
