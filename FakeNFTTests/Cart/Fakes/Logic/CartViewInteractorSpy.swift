import Foundation
import FakeNFT

final class CartViewInteractorSpy: CartViewInteractorProtocol {
    var isOrderEmpty = false

    let cost: Double = 2
    
    lazy var model = NFTCartCellViewModelFactory.makeNFTCartCellViewModel(
        id: "",
        name: "asd",
        image: nil,
        rating: 1,
        price: self.cost
    )

    func fetchOrder(
        with id: String,
        onSuccess: @escaping FakeNFT.LoadingCompletionBlock<FakeNFT.CartViewModel.ViewState>,
        onFailure: @escaping FakeNFT.LoadingFailureCompletionBlock
    ) {
        onSuccess(self.getLoadingState(order: [self.model, self.model]))
    }

    func changeOrder(
        with id: String,
        nftIds: [String],
        onSuccess: @escaping FakeNFT.LoadingCompletionBlock<FakeNFT.CartViewModel.ViewState>,
        onFailure: @escaping FakeNFT.LoadingFailureCompletionBlock
    ) {
        onSuccess(self.getLoadingState(order: [self.model]))
    }
}

private extension CartViewInteractorSpy {
    func getLoadingState(order: OrderViewModel) -> CartViewModel.ViewState {
        self.isOrderEmpty ? .empty : .loaded(order, self.cost)
    }
}
