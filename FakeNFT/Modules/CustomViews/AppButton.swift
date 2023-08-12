//
//  AppButton.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 01.08.2023.
//

import UIKit

final class AppButton: UIButton {
    private let type: ButtonType
    private let title: String

    init(type: ButtonType, title: String) {
        self.type = type
        self.title = title
        super.init(frame: .zero)

        self.configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppButton {
    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = true

        switch self.type {
        case .filled:
            self.setFilledType()
        case .bordered:
            self.setBorderedType()
        case .nftCartRemove, .nftCartCancel:
            self.setNftCartButton(type: self.type)
        }
    }

    func setFilledType() {
        self.backgroundColor = .appBlack

        let font = Constants.filledTypeFont
        let textColor = UIColor.appWhite
        let titleAttributes = [NSAttributedString.Key.font: font,
                               NSAttributedString.Key.foregroundColor: textColor]
        let title = NSAttributedString(string: self.title, attributes: titleAttributes)
        self.setAttributedTitle(title, for: .normal)
    }

    func setBorderedType() {
        let color = UIColor.appBlack

        self.backgroundColor = .clear
        self.layer.borderWidth = Constants.borderWidth
        self.layer.borderColor = color.cgColor

        let font = Constants.borderedTypeFont
        let title = NSAttributedString(string: self.title, attributes: [NSAttributedString.Key.font: font,
                                                                        NSAttributedString.Key.foregroundColor: color])
        self.setAttributedTitle(title, for: .normal)
    }

    func setNftCartButton(type: ButtonType) {
        self.backgroundColor = .appBlack

        let font = Constants.nftCartTypeFont
        let color = self.getColorForNftCartButton(type: type)

        let title = NSAttributedString(string: self.title, attributes: [NSAttributedString.Key.font: font,
                                                                        NSAttributedString.Key.foregroundColor: color])
        self.setAttributedTitle(title, for: .normal)
    }
}

private extension AppButton {
    func getColorForNftCartButton(type: ButtonType) -> UIColor {
        switch type {
        case .nftCartCancel:
            return .appWhite
        case .nftCartRemove:
            return .appRed
        default:
            return .appWhite
        }
    }
}

// MARK: - Constants
private extension AppButton {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1

        static var filledTypeFont: UIFont { UIFont.getFont(style: .bold, size: 17) }
        static var borderedTypeFont: UIFont { UIFont.getFont(style: .regular, size: 15) }
        static var nftCartTypeFont: UIFont { UIFont.getFont(style: .regular, size: 17) }
    }
}

// MARK: - Enums
extension AppButton {
    enum ButtonType {
        case filled
        case bordered
        case nftCartRemove
        case nftCartCancel
    }
}
