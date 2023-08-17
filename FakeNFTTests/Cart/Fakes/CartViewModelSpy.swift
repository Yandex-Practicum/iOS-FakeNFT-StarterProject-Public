import Foundation
import FakeNFT

final class CartViewModelSpy {
    var didFetchOrderCalled: Bool = false
}

// MARK: - CartViewModelProtocol
extension CartViewModelSpy: CartViewModelProtocol {
    var order: FakeNFT.Box<FakeNFT.OrderViewModel> { Box([]) }
    var nftCount: FakeNFT.Box<String> { Box("0") }
    var finalOrderCost: FakeNFT.Box<String> { Box("0") }
    var cartViewState: FakeNFT.Box<FakeNFT.CartViewModel.ViewState> { Box(.empty) }
    var error: FakeNFT.Box<Error?> { Box(nil) }
    var tableViewChangeset: FakeNFT.Changeset<FakeNFT.NFTCartCellViewModel>? { nil }
    var orderId: String { "1" }

    func fetchOrder() {
        self.didFetchOrderCalled = true
    }

    func sortOrder(trait: FakeNFT.CartOrderSorter.SortingTrait) {}
    func removeNft(row: Int) {}
}
