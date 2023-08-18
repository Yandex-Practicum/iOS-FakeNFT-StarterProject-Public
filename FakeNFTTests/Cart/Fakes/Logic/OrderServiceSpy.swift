import Foundation
import FakeNFT

final class OrderServiceSpy {
    enum TestRequestResult {
        case success
        case failure
    }

    enum TestError: Error {
        case test
    }

    var didFetchOrderCalled = false
    var didChangeOrderCalled = false
    var didPurchaseCalled = false

    var orderModel: Order?
    var neededRequestResult: TestRequestResult = .success
}

// MARK: - OrderServiceProtocol
extension OrderServiceSpy: OrderServiceProtocol {
    func fetchOrder(
        id: String,
        completion: @escaping FakeNFT.ResultHandler<FakeNFT.Order>
    ) {
        self.didFetchOrderCalled = true

        switch self.neededRequestResult {
        case .success:
            let orderModel = Order(id: "123", nfts: ["123", "512"])
            self.orderModel = orderModel
            completion(.success(orderModel))
        case .failure:
            completion(.failure(TestError.test))
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
        let purchaseState = self.neededRequestResult == .success
        completion(.success(PurchaseResult(id: "123", orderId: "123", success: purchaseState)))
    }
}
