import Foundation

struct UsersRequest: NetworkRequest {
    let page: Int
    let size: Int
    
    init(page: Int = 0, size: Int = 20) {
        self.page = page
        self.size = size
    }
    
    var endpoint: URL? {
    
        let urlString = "\(RequestConstants.baseURL)/api/v1/users?page=\(page)&size=\(size)"
        print("🌐 URL запроса: \(urlString)")
        return URL(string: urlString)
    }
    
    var dto: Dto? {
        return nil
    }
}

struct UserRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
    
    var dto: Dto? {
        return nil
    }
}
