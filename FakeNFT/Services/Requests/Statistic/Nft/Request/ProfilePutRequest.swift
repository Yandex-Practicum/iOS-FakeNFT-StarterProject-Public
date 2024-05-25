import Foundation

struct ProfilePutRequest: NetworkRequest {
    
    let profile: Profile
    var dto: Encodable?
    var httpMethod: HttpMethod = .put
    var endpoint: URL? {
        var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
        var components: [URLQueryItem] = []
        
        for like in profile.likes {
            components.append(URLQueryItem(name: "likes", value: like))
        }
        
        urlComponents?.queryItems = components
        return urlComponents?.url
    }
    
    var isUrlEncoded: Bool {
        return true
    }
}
