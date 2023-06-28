import Foundation

struct PutProfileRequest: NetworkRequest {
    struct Body: Encodable {
        let name: String
        let description: String
        let website: String
        let likes: [String]
    }
    
    var endpoint: URL? {
        URL(string: "https://648cbbf38620b8bae7ed510b.mockapi.io/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod = .put
    
    var body: Data?
    
    init(
        name: String,
        description: String,
        website: String,
        likes: [String]
    ) {
        self.body = try? JSONEncoder().encode(Body(
            name: name,
            description: description,
            website: website,
            likes: likes
        ))
    }
}
