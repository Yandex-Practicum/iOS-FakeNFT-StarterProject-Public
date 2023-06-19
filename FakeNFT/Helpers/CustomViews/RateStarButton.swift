//
//  RateStarButton.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

class RateStarButton: UIButton {

    init(appearance: Appearance) {
        super.init(frame: .zero)
        setAppearance(for: appearance)
        
        widthAnchor.constraint(equalToConstant: 11.75).isActive = true
        heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RateStarButton {
    func setAppearance(for appearance: Appearance) {
        switch appearance {
        case .active:
            setImage(UIImage(named: K.Icons.activeStarRate), for: .normal)
            isEnabled = true
        case .notActive:
            setImage(UIImage(named: K.Icons.notActiveStarRate), for: .normal)
            isEnabled = false
        }
    }
}

extension RateStarButton {
    enum Appearance {
        case active, notActive
    }
}
