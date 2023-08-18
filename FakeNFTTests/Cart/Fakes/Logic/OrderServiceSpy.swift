import Foundation
import FakeNFT

final class OrderServiceSpy {
    enum TestPurchaseResult {
        case success
        case failure
    }

    let order = """
        {
            "nfts":["95"],
            "id":"1"
        }
    """

    var didFetchOrderCalled = false
    var didChangeOrderCalled = false
    var didPurchaseCalled = false

    var orderModel: Order?
    var neededPurchaseResult: TestPurchaseResult = .success
}

// MARK: - OrderServiceProtocol
extension OrderServiceSpy: OrderServiceProtocol {
    func fetchOrder(
        id: String,
        completion: @escaping FakeNFT.ResultHandler<FakeNFT.Order>
    ) {
        self.didFetchOrderCalled = true
        guard let data = self.order.data(using: .utf8) else { return }

        do {
            let orderModel = try JSONDecoder().decode(Order.self, from: data)
            self.orderModel = orderModel
            completion(.success(orderModel))
        } catch {
            completion(.failure(error))
            assertionFailure(error.localizedDescription)
        }
    }

    func changeOrder(
        id: String,
        nftIds: [String],
        completion: @escaping FakeNFT.ResultHandler<FakeNFT.Order>
    ) {
        self.didChangeOrderCalled = true
    }
}

// MARK: - OrderPaymentServiceProtocol
extension OrderServiceSpy: OrderPaymentServiceProtocol {
    func purchase(
        orderId: String,
        currencyId: String,
        completion: @escaping FakeNFT.ResultHandler<FakeNFT.PurchaseResult>
    ) {
        self.didPurchaseCalled = true
        let purchaseState = self.neededPurchaseResult == .success
        completion(.success(PurchaseResult(id: "123", orderId: "123", success: purchaseState)))
    }
}
