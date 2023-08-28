import Foundation

// MARK: - Structure for querying the "Author" entity by id

struct AuthorByIdRequest: NetworkRequest {
    private let id: String
    init(id: String) {
        self.id = id
    }
    // MARK: - URL to request author profile by id
    
    var endpoint: URL? {
        return URL(string: ProfileConstants.endpoint + ProfileConstants.apiV1UsersUserIdGet + id)
    }
}

// MARK: - Structure for querying the "NFT" entity by id

struct  NftByIdRequest: NetworkRequest {
    private let id: String
    init(id: String) {
        self.id = id
    }
    // MARK: - URL to request NFC by id
    
    var endpoint: URL? {
        return URL(string: ProfileConstants.endpoint + ProfileConstants.apiV1NftNftIdGet + id)
    }
}

// MARK: - Structure for querying the user profile

struct  UserProfileRequest: NetworkRequest {
    var endpoint: URL? {
        return URL(string: ProfileConstants.endpoint + ProfileConstants.apiV1Profile1Get)
    }
}

// MARK: - Structure for update user profile

struct ProfileUpdateRequest: NetworkRequest {
    // URL to user profile update
    
    var endpoint: URL? {
        return URL(string: ProfileConstants.endpoint + ProfileConstants.apiV1Profile1Get)
    }
    // selected http method for request
    
    var httpMethod: HttpMethod {
        return .put
    }
    // data for sending
    
    var dto: Encodable?
    init(updatedData: ProfileResponseModel) {
        self.dto = updatedData
    }
}
