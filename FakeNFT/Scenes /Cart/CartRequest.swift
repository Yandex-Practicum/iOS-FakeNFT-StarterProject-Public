import Foundation

struct CartRequest: NetworkRequest {
    var endpoint: URL?
    init() {
        guard let endpoint = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1") else { return }
        self.endpoint = endpoint
    }
}
