import UIKit

enum CartSegue {
    case pay
    case choicePayment
    case purchaseResult
}

protocol CartRouter {
    func perform(_ segue: CartSegue, from source: CartViewController)
}

final class DefaultCartRouter: CartRouter {
    
    unowned var viewModel: CartViewModel
    
    init(viewModel: CartViewModelProtocol = CartViewModel()) {
        self.viewModel = viewModel as! CartViewModel
    }
    
    func perform(_ segue: CartSegue, from source: CartViewController) {
        switch segue {
        case .pay:
            let vc = DefaultCartRouter.makePaymentViewController()
            source.navigationController?.pushViewController(vc, animated: true)
        case .choicePayment:
            let vc = DefaultCartRouter.makePaymentViewController()
            source.navigationController?.pushViewController(vc, animated: true)
        case .purchaseResult:
            let vc = DefaultCartRouter.makePaymentViewController()
            source.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    static func makeCartViewController() -> UINavigationController {
        let vc = CartViewController()
        vc.viewModel = CartViewModel()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
    
    static func makePaymentViewController() -> UINavigationController {
        let vc = PaymentChoiceViewController()
        vc.modalPresentationStyle = .fullScreen
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
    
    static func makePurchaseViewController() -> UINavigationController {
        let vc = PurchaseResultViewController()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
}

