import Foundation

struct OrderRequest: NetworkRequest {
	var endpoint: URL? = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
}
