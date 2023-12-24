import Foundation

struct ProfilePutRequest: NetworkRequest {
    
    //let dto: Encodable?
    let httpMethod: HttpMethod = .put
    
    let profileModelEditing: ProfileModelEditing
    
    var endpoint: URL? {
        var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
        var components: [URLQueryItem] = []
        if let name = profileModelEditing.name {
            components.append(URLQueryItem(name: "name", value: name))
        }
        if let avatar = profileModelEditing.avatar {
            components.append(URLQueryItem(name: "avatar", value: avatar))
        }
        if let description = profileModelEditing.description {
            components.append(URLQueryItem(name: "description", value: description))
        }
        if let website = profileModelEditing.website {
            components.append(URLQueryItem(name: "website", value: website))
        }
        urlComponents?.queryItems = components

        return urlComponents?.url
    }
}
