//
//  LoginTextField.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 11.07.2023.
//

import UIKit

class LoginTextField: UITextField {
    
    var textPadding = UIEdgeInsets(
            top: 11,
            left: 16,
            bottom: 11,
            right: 16
        )

    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .ypLightGrey
        layer.cornerRadius = 12
        heightAnchor.constraint(equalToConstant: 46).isActive = true
        placeholder = title
        clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
}
