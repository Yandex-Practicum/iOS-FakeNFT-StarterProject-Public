import Foundation

struct ProfileRequest: NetworkRequest {
    var dto: (any Dto)?
    
    let profileId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(profileId)")
    }

    var httpMethod: HttpMethod = .get
}
