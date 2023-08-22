@testable import FakeNFT
import XCTest

final class CartViewControllerTests: XCTestCase {
    func testCartViewControllerCallsFetchOrder() {
        let viewModel = CartViewModelSpy()
        let helper = CartTableViewHelperStub()
        let router = CartViewRouterSpy()

        let viewController = CartViewController(
            viewModel: viewModel,
            tableViewHelper: helper,
            router: router
        )

        viewController.viewWillAppear(true)

        XCTAssertTrue(viewModel.didFetchOrderCalled)
    }

    func testCartViewControllerInvokesUITableViewMethods() {
        let viewModel = CartViewModelSpy()
        let helper = CartTableViewHelperStub()
        let router = CartViewRouterSpy()

        let viewController = CartViewController(
            viewModel: viewModel,
            tableViewHelper: helper,
            router: router
        )

        viewController.viewDidLoad()

        XCTAssertTrue(helper.didNumberOfRowsInSectonsCalled)
        XCTAssertTrue(helper.didCellForRowCalled)
    }

    func testCartViewControllerInvokesRemovingNFTFromOrder() {
        let viewModel = CartViewModelSpy()
        let helper = CartTableViewHelper()
        let router = CartViewRouterSpy()

        let viewController = CartViewController(
            viewModel: viewModel,
            tableViewHelper: helper,
            router: router
        )

        viewController.viewDidLoad()

        viewController.cartTableViewHelper(helper, removeRow: viewModel.removeNftRow, with: nil)
        XCTAssertTrue(viewModel.didRemoveNftCalledProperly)
    }
}
