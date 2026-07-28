import Foundation

// MARK: - Запросы для Корзины и Оплаты

/// GET /api/v1/orders/1
struct GetOrderRequest: NetworkRequest {
    let endpoint: URL? = URL(string: RequestConstants.baseURL + "/api/v1/orders/1")
    let httpMethod: HttpMethod = .get
    let dto: Dto? = nil
}

/// PUT /api/v1/orders/1
struct UpdateOrderDto: Dto {
    let nftIds: [String]
    
    func asDictionary() -> [String: String] {
        return ["nfts": nftIds.joined(separator: ",")]
    }
}

struct UpdateOrderRequest: NetworkRequest {
    let endpoint: URL? = URL(string: RequestConstants.baseURL + "/api/v1/orders/1")
    let httpMethod: HttpMethod = .put
    let dto: Dto?
    
    init(nftIds: [String]) {
        self.dto = UpdateOrderDto(nftIds: nftIds)
    }
}

/// GET /api/v1/nft/{nft_id}
struct GetNftRequest: NetworkRequest {
    let endpoint: URL?
    let httpMethod: HttpMethod = .get
    let dto: Dto? = nil
    
    init(nftId: String) {
        self.endpoint = URL(string: RequestConstants.baseURL + "/api/v1/nft/\(nftId)")
    }
}

/// GET /api/v1/currencies
struct GetCurrenciesRequest: NetworkRequest {
    let endpoint: URL? = URL(string: RequestConstants.baseURL + "/api/v1/currencies")
    let httpMethod: HttpMethod = .get
    let dto: Dto? = nil
}

/// GET /api/v1/orders/1/payment/{currency_id}
struct PayOrderRequest: NetworkRequest {
    let endpoint: URL?
    let httpMethod: HttpMethod = .get
    let dto: Dto? = nil
    
    init(currencyId: String) {
        self.endpoint = URL(string: RequestConstants.baseURL + "/api/v1/orders/1/payment/\(currencyId)")
    }
}

// MARK: - Complete Order Request (Выполнение и очистка)
struct CompleteOrderDto: Dto {
    let nftIds: [String]
    
    func asDictionary() -> [String: String] {
        return ["nfts[]": ""]
    }
}

struct CompleteOrderRequest: NetworkRequest {
    let endpoint: URL? = URL(string: RequestConstants.baseURL + "/api/v1/orders/1")
    let httpMethod: HttpMethod = .post
    let dto: Dto?
    
    init(nftIds: [String] = []) {
        self.dto = CompleteOrderDto(nftIds: nftIds)
    }
}
