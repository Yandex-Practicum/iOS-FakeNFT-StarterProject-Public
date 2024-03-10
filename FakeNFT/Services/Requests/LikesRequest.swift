import Foundation

struct LikesRequest: NetworkRequest {
	var endpoint: URL? = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
}
