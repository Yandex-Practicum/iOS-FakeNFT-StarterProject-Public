//
//  CartDeleteConfirmView.swift
//  FakeNFT
//
//  Created by Александр Акимов on 23.04.2024.
//

import UIKit

final class CartDeleteConfirmView: UIViewController {
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Cart.payBttn", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func configureView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        
    }
    
}
