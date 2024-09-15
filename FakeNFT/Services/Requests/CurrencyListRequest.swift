import Foundation

struct CurrencyListRequest: NetworkRequest {
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
  }
  var dto: (any Dto)?
}
