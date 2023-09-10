import Foundation

struct PaymentModel: Codable {
    let success: Bool
    let id, orderID: String
    
    enum CodingKeys: String, CodingKey {
        case success, id
        case orderID = "orderId"
    }
}
