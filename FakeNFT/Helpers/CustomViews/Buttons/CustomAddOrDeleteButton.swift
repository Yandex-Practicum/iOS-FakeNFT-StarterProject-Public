//
//  CustomAddOrDeleteButton.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 04.07.2023.
//

import UIKit

class CustomAddOrDeleteButton: UIButton {
    
    init(appearance: Appearance) {
        super.init(frame: .zero)
        setAppearance(for: appearance)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CustomAddOrDeleteButton {
    func setAppearance(for appearance: Appearance) {
        switch appearance {
        case .add:
            setImage(UIImage(named: K.Icons.addToCart)?.withTintColor(.ypBlack ?? .black, renderingMode: .alwaysOriginal), for: .normal)
        case .delete:
            setImage(UIImage(named: K.Icons.deleteFromCart)?.withTintColor(.ypBlack ?? .black, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
    
    func updateAppearence(isInCart: Bool) {
        isInCart ? setAppearance(for: .delete) : setAppearance(for: .add)
    }
}

extension CustomAddOrDeleteButton {
    enum Appearance {
        case add, delete
    }
}
