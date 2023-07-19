//
//  CustomLikeButton.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 04.07.2023.
//

import UIKit

class CustomLikeButton: UIButton {

    init(appearance: Appearance) {
        super.init(frame: .zero)
        setAppearance(for: appearance)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CustomLikeButton {
    func setAppearance(for appearance: Appearance) {
        switch appearance {
        case .favourite:
            setImage(UIImage(named: K.Icons.activeLike), for: .normal)
        case .normal:
            setImage(UIImage(named: K.Icons.notActiveLike), for: .normal)
        }
    }
    
    func updateButtonAppearence(isLiked: Bool) {
        isLiked ? setAppearance(for: .favourite) : setAppearance(for: .normal)
    }
}

extension CustomLikeButton {
    enum Appearance {
        case favourite, normal
    }
}
