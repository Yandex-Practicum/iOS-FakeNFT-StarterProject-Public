import Foundation

struct PurchaseRequest: NetworkRequest {
    let orderId: String
    let currencyId: String

    var endpoint: URL? {
        let api = AppConstants.Api.self
        var components = URLComponents(string: api.defaultEndpoint)
        let apiVersion = api.version
        let ordersController = api.Cart.controller
        let paymentController = api.Cart.paymentController
        components?.path = "\(apiVersion)/\(ordersController)/\(orderId)/\(paymentController)/\(currencyId)"
        return components?.url
    }
}
