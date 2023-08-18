import UIKit.UIViewController
import FakeNFT

final class CartPaymentRouterSpy: CartPaymentRouterProtocol {
    var didShowUserAgreementWebViewCalled = false
    var didShowPaymentResultCalled = false

    var recievedPaymentResultType: CartPaymentResultViewController.ResultType?

    func showUserAgreementWebView(
        on viewController: UIViewController,
        urlString: String
    ) {

    }

    func showPaymentResult(
        on viewController: UIViewController,
        resultType: FakeNFT.CartPaymentResultViewController.ResultType,
        resultButtonAction: @escaping FakeNFT.ActionCallback<Void>
    ) {
        self.didShowPaymentResultCalled = true
        self.recievedPaymentResultType = resultType
    }

    func showErrorAlert(
        on viewController: UIViewController,
        error: Error
    ) {

    }
}
