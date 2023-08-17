@testable import FakeNFT
import XCTest

final class CartViewTests: XCTestCase {
    func testCartViewControllerCallsFetchOrder() {
        let viewModel = CartViewModelSpy()
        let tableViewHelper = CartTableViewHelperStub()
        let router = CartViewRouterSpy()

        let viewController = CartViewController(
            viewModel: viewModel,
            tableViewHelper: tableViewHelper,
            router: router
        )

        viewController.viewWillAppear(true)

        XCTAssertTrue(viewModel.didFetchOrderCalled)
    }
}
