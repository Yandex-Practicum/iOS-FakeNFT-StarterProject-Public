import Foundation

final class GetPaymentRequest: NetworkRequest {
    var dto: (any Dto)?
    
    var httpMethod: HttpMethod
    var currencyId: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }
    
    init(httpMethod: HttpMethod, currencyId: String) {
        self.httpMethod = httpMethod
        self.currencyId = currencyId
    }
}
