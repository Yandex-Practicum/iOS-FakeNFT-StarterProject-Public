import Foundation

struct PutProfileRequest: NetworkRequest {
    struct Body: Encodable {
        let name: String
        let avatar: String
        let description: String
        let website: String
        let likes: [String]
    }
    
    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent(NetworkConstants.profileEndpoint)
    }
    
    var httpMethod: HttpMethod = .put
    
    var body: Data?
    
    init(
        name: String,
        avatar: String,
        description: String,
        website: String,
        likes: [String]
    ) {
        self.body = try? JSONEncoder().encode(Body(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            likes: likes
        ))
    }
}
