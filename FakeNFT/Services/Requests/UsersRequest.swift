import Foundation

struct UsersRequest: NetworkRequest {
	var sortBy: SortBy?
	
	var endpoint: URL? {
		guard let sortBy else {
			return URL(string: "\(RequestConstants.baseURL)/api/v1/users")
		}
		return URL(string: "\(RequestConstants.baseURL)/api/v1/users?sortBy=\(sortBy.rawValue)")
	}
	
	init(sortBy: SortBy? = nil) {
		self.sortBy = sortBy
	}
}
