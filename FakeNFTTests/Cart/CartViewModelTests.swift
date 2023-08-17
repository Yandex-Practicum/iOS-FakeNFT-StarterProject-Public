@testable import FakeNFT
import XCTest

final class CartViewModelTests: XCTestCase {
    private let interactor = CartViewInteractorSpy()
    private let orderSorter = CartOrderSorterSpy()

    func testCartViewModelFetchingOrder() {
        let viewModel = CartViewModel(intercator: self.interactor, orderSorter: self.orderSorter)

        let expectedModel = interactor.model

        viewModel.fetchOrder()

        XCTAssertTrue(viewModel.order.value.first == expectedModel)
    }

    func testCartViewModelSortingOrder() {
        let viewModel = CartViewModel(intercator: self.interactor, orderSorter: self.orderSorter)
        let expectedTrait = orderSorter.selectedSortingTrait

        viewModel.sortOrder(trait: expectedTrait)

        XCTAssertTrue(orderSorter.didSortingCalled)
        XCTAssertTrue(orderSorter.selectedSortingTrait == expectedTrait)
        XCTAssertTrue(viewModel.order.value == orderSorter.sortedOrder)
    }

    func testCartViewModelRemovingNFTFromOrder() {
        let viewModel = CartViewModel(intercator: self.interactor, orderSorter: self.orderSorter)

        let expectedOrderCapacity = 1
        let expectedModel = interactor.model

        viewModel.fetchOrder()
        viewModel.removeNft(row: 1)

        XCTAssertTrue(viewModel.order.value.count == expectedOrderCapacity)
        XCTAssertTrue(viewModel.order.value.first == expectedModel)
    }
}
