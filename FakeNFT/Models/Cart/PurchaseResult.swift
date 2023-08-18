import Foundation

public struct PurchaseResult: Decodable {
    let id: String
    let orderId: String
    let success: Bool

    public init(id: String, orderId: String, success: Bool) {
        self.id = id
        self.orderId = orderId
        self.success = success
    }
}
