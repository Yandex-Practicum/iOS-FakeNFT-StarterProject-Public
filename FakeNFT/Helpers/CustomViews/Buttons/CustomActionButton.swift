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
        
        layer.cornerRadius = cornerRadius ?? 16
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: fontWeight ?? .bold)
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
        case .transparent:
            setTitleColor(.ypBlack, for: .normal)
            backgroundColor = .clear
            isEnabled = true
        case .demo:
            setTitleColor(.universalBlue, for: .normal)
            backgroundColor = .clear
            isEnabled = true
        }
    }
}

extension CustomActionButton {
    enum Appearance {
        case disabled, confirm, cancel, transparent, demo
    }
}
