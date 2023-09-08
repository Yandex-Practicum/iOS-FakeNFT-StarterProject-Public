import UIKit

protocol Router {
    func route(
        to routeID: String,
        from context: UIViewController
    )
}

final class CartRouter: Router {

    unowned var viewModel: CartViewModel

    init(viewModel: CodeInputViewModelProtocol = CartViewModel()) {
        self.viewModel = viewModel as! CartViewModel
    }

    func route(to routeID: String, from context: UIViewController) {
        guard let route = CartViewController.Route(rawValue: routeID) else {
            return
        }
        switch route {
        case .pay:
            let vc = PaymentChoiceViewController()
            context.navigationController?.pushViewController(vc, animated: true)
        case .paymentChoice: break

        case .purchasResult: break

        }
    }
}
//
//
//class BaseRouter {
//    init(sourceViewController: UIViewController) {
//        self.sourceViewController = sourceViewController
//    }
//    
//    weak var sourceViewController: UIViewController?
//}
//
//final class Router: BaseRouter {
//    func showVC() {
//        let vc = PaymentChoiceViewController()
//        vc.modalPresentationStyle = .fullScreen
//        sourceViewController?.present(vc, animated: true)
//    }
//}
