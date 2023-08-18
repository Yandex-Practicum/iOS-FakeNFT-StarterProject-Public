import Foundation
import FakeNFT

final class CartViewModelSpy {
    var didFetchOrderCalled: Bool = false
    var didRemoveNftCalledProperly = false

    var order: FakeNFT.OrderViewModel = []

    let removeNftRow = 0

    let model = NFTCartCellViewModelFactory.makeNFTCartCellViewModel(
        id: "",
        name: "",
        image: nil,
        rating: 1,
        price: 1
    )
}

// MARK: - CartViewModelProtocol
extension CartViewModelSpy: CartViewModelProtocol {

    var nftCount: FakeNFT.Box<String> { Box("0") }
    var finalOrderCost: FakeNFT.Box<String> { Box("0") }
    var cartViewState: FakeNFT.Box<FakeNFT.CartViewModel.ViewState> { Box(.empty) }
    var error: FakeNFT.Box<Error?> { Box(nil) }
    var tableViewChangeset: FakeNFT.Box<FakeNFT.Changeset<FakeNFT.NFTCartCellViewModel>?> {
        Box(Changeset(oldItems: [self.model], newItems: [self.model]))
    }
    
    var orderId: String { "1" }

    func fetchOrder() {
        self.didFetchOrderCalled = true
        self.order = [self.model]
    }

    func sortOrder(trait: FakeNFT.CartOrderSorter.SortingTrait) {}

    func removeNft(row: Int) {
        if self.removeNftRow == row {
            self.didRemoveNftCalledProperly = true
        }
    }
}
