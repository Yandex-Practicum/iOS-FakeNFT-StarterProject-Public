// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Корзина
  internal static let cartTabBarTitle = L10n.tr("Localizable", "cartTabBarTitle", fallback: "Корзина")
  /// Close
  internal static let catalogClose = L10n.tr("Localizable", "catalogClose", fallback: "Close")
  /// By Name
  internal static let catalogSortByName = L10n.tr("Localizable", "catalogSortByName", fallback: "By Name")
  /// By NFT Count
  internal static let catalogSortByNFTCount = L10n.tr("Localizable", "catalogSortByNFTCount", fallback: "By NFT Count")
  /// Sorting
  internal static let catalogSorting = L10n.tr("Localizable", "catalogSorting", fallback: "Sorting")
  /// Каталог
  internal static let catalogTabBarTitle = L10n.tr("Localizable", "catalogTabBarTitle", fallback: "Каталог")
  /// Collection Author:
  internal static let collectionAboutAuthor = L10n.tr("Localizable", "collectionAboutAuthor", fallback: "Collection Author:")
  /// Профиль
  internal static let profileTabBarTitle = L10n.tr("Localizable", "profileTabBarTitle", fallback: "Профиль")
  /// Статистика
  internal static let statisticTabBarTitle = L10n.tr("Localizable", "statisticTabBarTitle", fallback: "Статистика")
  internal enum Catalog {
    /// Открыть Nft
    internal static let openNft = L10n.tr("Localizable", "Catalog.openNft", fallback: "Открыть Nft")
  }
  internal enum Error {
    /// Произошла ошибка сети
    internal static let network = L10n.tr("Localizable", "Error.network", fallback: "Произошла ошибка сети")
    /// Повторить
    internal static let `repeat` = L10n.tr("Localizable", "Error.repeat", fallback: "Повторить")
    /// Ошибка
    internal static let title = L10n.tr("Localizable", "Error.title", fallback: "Ошибка")
    /// Произошла неизвестная ошибка
    internal static let unknown = L10n.tr("Localizable", "Error.unknown", fallback: "Произошла неизвестная ошибка")
  }
  internal enum Tab {
    /// Каталог
    internal static let catalog = L10n.tr("Localizable", "Tab.catalog", fallback: "Каталог")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type