//
//  ActionButton.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 25/06/2024.
//

import UIKit

// MARK: - ButtonSize

enum ButtonSize {
    case large
    case medium
    case small
}

// MARK: - ButtonType

enum CustomButtonType {
    case primary
    case destructive
}

// MARK: - ActionButton

class ActionButton: UIButton {
    
    // MARK: - Private Properties
    
    private let buttonSize: ButtonSize
    private let customButtonType: CustomButtonType
    
    private var cornerRadius: CGFloat {
        switch buttonSize {
        case .large:
            return 16
        case .medium, .small:
            return 12
        }
    }
    
    private var font: UIFont {
        switch buttonSize {
        case .large:
            return .bodyBold
        case .medium:
            return .bodyBold
        case .small:
            return .bodyRegular
        }
    }
    
    private var titleColor: UIColor {
        switch customButtonType {
        case .primary:
            return .ypWhiteDay
        case .destructive:
            return .ypRed
        }
    }
    
    private var buttonSizeValue: CGSize {
        switch buttonSize {
        case .large:
            return CGSize(width: 343, height: 60)
        case .medium:
            return CGSize(width: 240, height: 44)
        case .small:
            return CGSize(width: 127, height: 44)
        }
    }
    
    // MARK: - Initialization
    
    init(size: ButtonSize, type: CustomButtonType, title: String) {
        self.buttonSize = size
        self.customButtonType = type
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupButton() {
        layer.cornerRadius = cornerRadius
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = font
        
        switch customButtonType {
        case .primary:
            backgroundColor = .ypBlackDay
        case .destructive:
            backgroundColor = .ypBlackDay
            setTitleColor(.ypRed, for: .normal)
        }
        
        setupButtonSize()
    }
    
    private func setupButtonSize() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: buttonSizeValue.width),
            heightAnchor.constraint(equalToConstant: buttonSizeValue.height)
        ])
    }
}

