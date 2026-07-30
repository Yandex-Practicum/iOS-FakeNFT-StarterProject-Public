//
//  PaymentCoordinator.swift
//  FakeNFT
//
//  Created by Сергей Петров on 23.07.2026.
//

import UIKit

// MARK: - Payment Action Enum
enum PaymentAction {
    case openAgreement(URL)
    case paymentSuccess(currency: Currency, total: Double)
    case cancelPayment
}

// MARK: - PaymentCoordinator
final class PaymentCoordinator {
    
    private let navigationController: UINavigationController
    private let cartItems: [CartItem]
    
    weak var parentCoordinator: AnyObject?
    
    init(navigationController: UINavigationController, cartItems: [CartItem]) {
        self.navigationController = navigationController
        self.cartItems = cartItems
    }
    
    func start() {
        let viewModel = PaymentViewModel(cartItems: cartItems)
        let paymentVC = PaymentViewController(viewModel: viewModel)
        
        paymentVC.onAction = { [weak self] action in
            self?.handleAction(action)
        }
        
        navigationController.pushViewController(paymentVC, animated: true)
    }
    
    private func handleAction(_ action: PaymentAction) {
        switch action {
        case .openAgreement(let url):
            let webVC = WebViewController(url: url)
            webVC.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(webVC, animated: true)
            
        case .paymentSuccess(_, _):
            let successVC = SuccessPaymentViewController { [weak self] in
                self?.navigationController.popToRootViewController(animated: true)
            }
            successVC.modalPresentationStyle = .fullScreen
            navigationController.present(successVC, animated: true)
            
        case .cancelPayment:
            navigationController.popViewController(animated: true)
        }
    }
}
