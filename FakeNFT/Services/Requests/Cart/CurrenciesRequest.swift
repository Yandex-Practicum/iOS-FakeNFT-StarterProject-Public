import Foundation

struct CurrenciesRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get

    var endpoint: URL? {
        let api = AppConstants.Api.self
        var components = URLComponents(string: api.defaultEndpoint)
        let apiVersion = api.version
        let currenciesController = api.Currencies.controller
        components?.path = "\(apiVersion)/\(currenciesController)"
        return components?.url
    }
}
