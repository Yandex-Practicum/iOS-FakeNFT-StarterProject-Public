import Foundation

struct EditOrderRequest: NetworkRequest {

  let newOrder: NewOrderModel

  var httpMethod: HttpMethod = .put

  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
  }
  var dto: (any Dto)?
}

struct NewOrderModel: Encodable {
  var nfts: [String]
}
