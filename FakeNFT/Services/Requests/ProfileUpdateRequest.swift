import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    let profileUpdateDTO: ProfileUpdateDTO
    var endpoint: URL? {
        URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Encodable? {
        profileUpdateDTO
    }
}

struct ProfileUpdateDTO: Encodable {
    let likes: [String]
    let id: String
}
