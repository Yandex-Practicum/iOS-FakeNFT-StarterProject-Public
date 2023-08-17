import Foundation
import FakeNFT

final class OrderServiceSpy: OrderServiceProtocol {
    var didFetchOrderCalled = false
    var didChangeOrderCalled = false

    let order = """
        {
            "nfts":["95"],
            "id":"1"
        }
    """

    var orderModel: Order?

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
