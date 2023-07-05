//
//  CustomHeartButton.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 04.07.2023.
//

import UIKit

class CustomHeartButton: UIButton {

    init(appearance: Appearance) {
        super.init(frame: .zero)
        setAppearance(for: appearance)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CustomHeartButton {
    func setAppearance(for appearance: Appearance) {
        switch appearance {
        case .favourite:
//            setImage(UIImage(systemName: K.Icons.heart)?.withTintColor(.universalRed), for: .normal)
            setImage(UIImage(systemName: K.Icons.heart)?.withTintColor(.universalRed, renderingMode: .alwaysOriginal), for: .normal)
        case .normal:
//            setImage(UIImage(systemName: K.Icons.heart)?.withTintColor(.universalWhite), for: .normal)
            setImage(UIImage(systemName: K.Icons.heart)?.withTintColor(.universalWhite, renderingMode: .alwaysOriginal), for: .normal)
        }
        
    }
}

extension CustomHeartButton {
    enum Appearance {
        case favourite, normal
    }
}
