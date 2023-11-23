// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Catalog {
    /// Открыть Nft
    internal static let openNft = L10n.tr("Localizable", "Catalog.openNft", fallback: "Открыть Nft")
  }
  internal enum CatalogCollection {
    /// Автор коллекции:
    internal static let authorLabel = L10n.tr("Localizable", "CatalogCollection.authorLabel", fallback: "Автор коллекции:")
  }
  internal enum CatalogFilterStorage {
    /// catalogFilter
    internal static let key = L10n.tr("Localizable", "CatalogFilterStorage.key", fallback: "catalogFilter")
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
  internal enum FilterAlert {
    /// Отменить
    internal static let cancelButtonTitle = L10n.tr("Localizable", "FilterAlert.cancelButtonTitle", fallback: "Отменить")
    /// По названию
    internal static let nameSortTitle = L10n.tr("Localizable", "FilterAlert.nameSortTitle", fallback: "По названию")
    /// По количеству NFT
    internal static let quantitySortTitle = L10n.tr("Localizable", "FilterAlert.quantitySortTitle", fallback: "По количеству NFT")
    /// Сортировка
    internal static let title = L10n.tr("Localizable", "FilterAlert.title", fallback: "Сортировка")
  }
  internal enum NetworkErrorAlert {
    /// Попробуйте еще раз
    internal static let message = L10n.tr("Localizable", "NetworkErrorAlert.message", fallback: "Попробуйте еще раз")
    /// OK
    internal static let okButton = L10n.tr("Localizable", "NetworkErrorAlert.okButton", fallback: "OK")
    /// Упс(
    internal static let title = L10n.tr("Localizable", "NetworkErrorAlert.title", fallback: "Упс(")
  }
  internal enum NftErrorAlert {
    /// Попробуйте еще раз
    internal static let message = L10n.tr("Localizable", "NftErrorAlert.message", fallback: "Попробуйте еще раз")
    /// OK
    internal static let okButton = L10n.tr("Localizable", "NftErrorAlert.okButton", fallback: "OK")
    /// Что-то пошло не так(
    internal static let title = L10n.tr("Localizable", "NftErrorAlert.title", fallback: "Что-то пошло не так(")
  }
  internal enum Tab {
    /// Каталог
    internal static let catalog = L10n.tr("Localizable", "Tab.catalog", fallback: "Каталог")
  }
  internal enum Tabbar {
    /// Каталог
    internal static let catalogTitle = L10n.tr("Localizable", "Tabbar.catalogTitle", fallback: "Каталог")
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
