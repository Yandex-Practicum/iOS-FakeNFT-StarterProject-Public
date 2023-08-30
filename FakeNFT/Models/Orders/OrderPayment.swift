import Foundation

struct OrderPayment: Decodable {
    let success: Bool
    let id: String
    let orderID: String
    
    enum CodingKeys: String, CodingKey {
        case success, id
        case orderID = "orderId"
    }
}
