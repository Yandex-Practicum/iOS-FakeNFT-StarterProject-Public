//
//  AppFontName.swift
//  FakeNFT
//
//  Created by Василий Ханин on 12.09.2025.
//

/*
 Пример использования
 Text("Заголовок")
    .font(.appBold22)

 Text("Описание")
    .font(.appRegular15)

 Text("Мелкий текст")
    .font(.appMedium10)
 */

import SwiftUI

enum AppFontName {
    static let regular = "SFProText-Regular"
    static let medium  = "SFProText-Medium"
    static let bold    = "SFProText-Bold"
}

extension Font {

    /// Medium 10
    static var appMedium10: Font {
        .custom(AppFontName.medium, size: 10)
    }

    /// Bold 22 (22/28)
    static var appBold22: Font {
        .custom(AppFontName.bold, size: 22)
    }

    /// Bold 17 (17/22)
    static var appBold17: Font {
        .custom(AppFontName.bold, size: 17)
    }

    /// Regular 13 (13/18)
    static var appRegular13: Font {
        .custom(AppFontName.regular, size: 13)
    }

    /// Regular 15 (15/20)
    static var appRegular15: Font {
        .custom(AppFontName.regular, size: 15)
    }

    /// Regular 17 (17/22)
    static var appRegular17: Font {
        .custom(AppFontName.regular, size: 17)
    }

    /// Bold 34 (34/41)
    static var appBold34: Font {
        .custom(AppFontName.bold, size: 34)
    }

    /// Bold 32 (32/41)
    static var appBold32: Font {
        .custom(AppFontName.bold, size: 32)
    }
}
