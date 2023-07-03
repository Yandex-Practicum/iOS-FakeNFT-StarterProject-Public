import Foundation

struct GetAuthorByIdRequest: NetworkRequest {
    private let id: String
    
    init(id: String) {
        self.id = id
    }
    
    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/users/\(id)")
    }
}
