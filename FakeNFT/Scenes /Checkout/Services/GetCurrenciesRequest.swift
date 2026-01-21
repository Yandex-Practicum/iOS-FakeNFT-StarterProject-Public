import Foundation

final class GetCurrenciesRequest: NetworkRequest {
    var dto: (any Dto)?
    
    var httpMethod: HttpMethod
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }

    init(httpMethod: HttpMethod) {
        self.httpMethod = httpMethod
    }
}
