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
            setImage(
                UIImage(
                    systemName: K.Icons.addItemToCart)?
                    .withTintColor(
                        .ypBlack ?? .black,
                        renderingMode: .alwaysOriginal
                    ),
                for: .normal)
        case .delete:
            setImage(
                UIImage(
                    systemName: K.Icons.deleteItemFromCart)?
                    .withTintColor(
                        .ypBlack ?? .black,
                        renderingMode: .alwaysOriginal
                    ),
                for: .normal)
        }
    }
}

extension CustomAddOrDeleteButton {
    enum Appearance {
        case add, delete
    }
}
