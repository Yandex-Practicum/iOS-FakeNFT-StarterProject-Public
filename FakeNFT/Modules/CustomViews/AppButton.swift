//
//  AppButton.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 01.08.2023.
//

import UIKit

final class AppButton: UIButton {
    enum ButtonType {
        case filled
        case bordered
        case nftCartRemove
        case nftCartCancel
    }

    private let cornerRadius: CGFloat = 16
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
        self.layer.cornerRadius = self.cornerRadius
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

        let font = UIFont.getFont(style: .bold, size: 17)
        let textColor = UIColor.appWhite
        let title = NSAttributedString(string: self.title, attributes: [NSAttributedString.Key.font: font,
                                                                        NSAttributedString.Key.foregroundColor: textColor])
        self.setAttributedTitle(title, for: .normal)
    }

    func setBorderedType() {
        let color = UIColor.appBlack

        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor

        let font = UIFont.getFont(style: .regular, size: 15)
        let title = NSAttributedString(string: self.title, attributes: [NSAttributedString.Key.font: font,
                                                                        NSAttributedString.Key.foregroundColor: color])
        self.setAttributedTitle(title, for: .normal)
    }

    func setNftCartButton(type: ButtonType) {
        self.backgroundColor = .appBlack

        let font = UIFont.getFont(style: .regular, size: 17)
        let color: UIColor

        switch type {
        case .nftCartCancel:
            color = .appWhite
        case .nftCartRemove:
            color = .appRed
        default:
            color = .appWhite
        }

        let title = NSAttributedString(string: self.title, attributes: [NSAttributedString.Key.font: font,
                                                                        NSAttributedString.Key.foregroundColor: color])
        self.setAttributedTitle(title, for: .normal)
    }
}
