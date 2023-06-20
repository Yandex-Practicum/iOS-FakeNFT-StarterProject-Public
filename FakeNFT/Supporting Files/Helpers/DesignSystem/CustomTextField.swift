//
//  CustomTextField.swift
//  FakeNFT
//
//  Created by Илья Валито on 20.06.2023.
//

import UIKit

class CustomTextField: UITextField {

    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)

        return originalRect.offsetBy(dx: -16, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 16, y: 0, width: bounds.size.width - 60, height: bounds.size.height)
    }
}
