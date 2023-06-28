//
//  CustomActionButton.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 19.06.2023.
//

import UIKit

final class CustomActionButton: UIButton {
    
    init(title: String, appearance: Appearance, cornerRadius: CGFloat? = nil, fontWeight: UIFont.Weight? = nil) {
        super.init(frame: .zero)
        setAppearance(for: appearance)
        setTitle(title, for: .normal)
        
        if let cornerRadius {
            layer.cornerRadius = cornerRadius
        } else {
            layer.cornerRadius = 16
        }
        
        if let fontWeight {
            titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: fontWeight)
        } else {
            titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        }
       
        titleLabel?.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomActionButton {
    func setAppearance(for appearance: Appearance) {
        switch appearance {
        case .disabled:
            setTitleColor(.ypBlack, for: .normal)
            backgroundColor = .universalBackground
            isEnabled = false
        case .confirm:
            setTitleColor(.ypWhite, for: .normal)
            backgroundColor = .ypBlack
            isEnabled = true
        case .cancel:
            setTitleColor(.universalRed, for: .normal)
            backgroundColor = .ypBlack
            isEnabled = true
        case .hidden:
            isHidden = true
            isEnabled = false
        }
        
    }
}

extension CustomActionButton {
    enum Appearance {
        case disabled, confirm, cancel, hidden
    }
}
