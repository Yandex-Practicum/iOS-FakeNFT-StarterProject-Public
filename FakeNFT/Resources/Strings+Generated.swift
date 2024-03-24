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
        /// Закрыть
        internal static let close = L10n.tr("Localizable", "catalog.Close", fallback: "Закрыть")
        /// По названию
        internal static let sortByName = L10n.tr("Localizable", "catalog.SortByName", fallback: "По названию")
        /// По количеству NFT
        internal static let sortByNFTCount = L10n.tr("Localizable", "catalog.SortByNFTCount", fallback: "По количеству NFT")
        /// Cортировка
        internal static let sorting = L10n.tr("Localizable", "catalog.Sorting", fallback: "Cортировка")
        internal enum Collection {
            /// Автор коллекции:
            internal static let aboutAuthor = L10n.tr("Localizable", "catalog.collection.AboutAuthor", fallback: "Автор коллекции:")
        }
    }

    internal enum Profile {
        /// Мои NFT
        internal static let myNFT = L10n.tr("Localizable", "Profile.myNFT", fallback: "Мои NFT")
        /// Избранные NFT
        internal static let favoritesNFT = L10n.tr("Localizable", "Profile.favoritesNFT", fallback: "Избранные NFT")
        /// О разработчике
        internal static let aboutDeveloper = L10n.tr("Localizable", "Profile.aboutDeveloper", fallback: "О разработчике")
        /// Имя
        internal static let name = L10n.tr("Localizable", "Profile.name", fallback: "Имя")
        /// Описание
        internal static let description = L10n.tr("Localizable", "Profile.description", fallback: "Описание")
        /// Сайт
        internal static let site = L10n.tr("Localizable", "Profile.site", fallback: "Сайт")
        /// Загрузить изображение
        internal static let loadAvatar = L10n.tr("Localizable", "Profile.loadAvatar", fallback: "Загрузить изображение")
        /// Сменить фото
        internal static let changeImage = L10n.tr("Localizable", "Profile.changeImage", fallback: "Сменить фото")
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

    internal enum TabBar {
        /// Корзина
        internal static let cartTabBarTitle = L10n.tr("Localizable", "tabBar.cartTabBarTitle", fallback: "Корзина")
        /// Каталог
        internal static let catalogTabBarTitle = L10n.tr("Localizable", "tabBar.catalogTabBarTitle", fallback: "Каталог")
        /// Профиль
        internal static let profileTabBarTitle = L10n.tr("Localizable", "tabBar.profileTabBarTitle", fallback: "Профиль")
        /// Статистика
        internal static let statisticTabBarTitle = L10n.tr("Localizable", "tabBar.statisticTabBarTitle", fallback: "Статистика")
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
