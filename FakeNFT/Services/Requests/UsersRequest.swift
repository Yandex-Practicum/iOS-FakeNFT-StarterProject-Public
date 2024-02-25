import Foundation

struct UsersRequest: NetworkRequest {
	var sortBy: String?
	
	var endpoint: URL? {
		guard let sortBy else {
			return URL(string: "\(RequestConstants.baseURL)/api/v1/users")
		}
		return URL(string: "\(RequestConstants.baseURL)/api/v1/users?sortBy=\(sortBy)")
	}
	
	init(sortBy: String? = nil) {
		self.sortBy = sortBy
	}
}
