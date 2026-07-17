//
//  CartSizeConstants.swift
//  FakeNFT
//
//  Created by Сергей Петров on 17.07.2026.
//

import UIKit

enum CartSizeConstants {

    // MARK: - Кнопки и Секции (Общие/CartView)

    // Кнопка "To Payment"
    static let paymentButtonWidth: CGFloat = 240
    static let paymentButtonHeight: CGFloat = 44
    static let buttonRadius: CGFloat = 16
    // Секция "Total"
    static let totalSectionHeight: CGFloat = 76
    static let totalSectionRadius: CGFloat = 20

    // MARK: - Элементы Списка (CartCell)

    static let cellImageSize: CGFloat = 108
    static let cellImageCornerRadius: CGFloat = 12

    // MARK: - Модальное окно (DeleteConfirmationView)

    // Изображение в модальном окне
    static let modalImageSize: CGFloat = 108
    static let modalImageRadius: CGFloat = 12
    // Общие константы для модальных кнопок
    static let modalButtonHeight: CGFloat = 44
    static let modalButtonRadius: CGFloat = 12
}
