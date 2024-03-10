import Foundation

struct PutLikesRequest: NetworkRequest {
	var httpMethod: HttpMethod = .put
	var dto: Encodable?
	var endpoint: URL? = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
	
	init(likes: [String]) {
	endpoint =
		URL(
			string: "\(RequestConstants.baseURL)/api/v1/profile/1?likes=" +
			likes.joined(separator: ",")
		)
	}
}
