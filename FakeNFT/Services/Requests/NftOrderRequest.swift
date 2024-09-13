import Foundation

struct NFTOrderRequest: NetworkRequest {
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
  }
  var dto: (any Dto)?
}
