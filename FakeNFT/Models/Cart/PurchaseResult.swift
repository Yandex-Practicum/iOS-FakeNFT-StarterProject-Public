import Foundation

public struct PurchaseResult: Decodable {
    let id: String
    let orderId: String
    let success: Bool
}
