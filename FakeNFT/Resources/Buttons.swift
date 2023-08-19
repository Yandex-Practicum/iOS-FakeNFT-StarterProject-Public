//
//  Buttons.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 02/08/2023.
//

import UIKit

class Button: UIButton {
    convenience init(title: String) {
        self.init(type: .system)

        setTitle(title, for: .normal)
        backgroundColor = .black

        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.bodyBold
        layer.cornerRadius = 16
    }

    func color(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }

    func titleColor(_ titleColor: UIColor) -> Self {
        setTitleColor(titleColor, for: .normal)
        return self
    }

    func font(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }

    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        layer.cornerRadius = cornerRadius
        return self
    }

    func border(width: CGFloat, color: UIColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
}
