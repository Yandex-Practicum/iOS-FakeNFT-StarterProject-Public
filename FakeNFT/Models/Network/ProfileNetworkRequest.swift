import Foundation

struct FetchProfileNetworkRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://651ff0d9906e276284c3c20a.mockapi.io/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        return .get
    }
}

struct UpdateProfileNetworkRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://651ff0d9906e276284c3c20a.mockapi.io/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        return .put
    }

    var dto: Encodable? {
        return profileDTO
    }

    let profileDTO: ProfileUpdateDTO

    init(userProfile: UserProfile) {
        profileDTO = ProfileUpdateDTO(from: userProfile)
    }
}
