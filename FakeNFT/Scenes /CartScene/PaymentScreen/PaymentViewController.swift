//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 27.06.2023.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupView()
    }
    
}

// MARK: - Private methods
extension PaymentViewController {
    
    /// Appearance customisation
    private func setupView() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
    /// Setting properties
    private func setupProperties() {
        title = "Выберите способ оплаты"
        view.backgroundColor = .white
    }
    
}
