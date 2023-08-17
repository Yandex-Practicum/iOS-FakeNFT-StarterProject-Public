import UIKit.UIViewController
import FakeNFT

final class CartViewRouterSpy: CartViewRouterProtocol {
    func showSortAlert(
        viewController: UIViewController,
        onChoosingSortingTrait: @escaping FakeNFT.ActionCallback<FakeNFT.CartOrderSorter.SortingTrait>
    ) {}

    func showRemoveNftView(
        on viewController: UIViewController,
        nftImage: UIImage?,
        onChoosingRemoveNft: @escaping FakeNFT.ActionCallback<FakeNFT.CartRemoveNftViewController.RemoveNftFlow>
    ) {}

    func showErrorAlert(on viewController: UIViewController, error: Error) {}
    func showCartPayment(on viewController: UIViewController, orderId: String) {}
}
