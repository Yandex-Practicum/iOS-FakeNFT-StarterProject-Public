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
    internal enum Onboarding {
        /// Что внутри?
        internal static let buttonText = L10n.tr("Localizable", "Onboarding.buttonText", fallback: "Что внутри?")
        /// Присоединяйтесь и откройте новый мир уникальных NFT для коллекционеров
        internal static let infoFirst = L10n.tr("Localizable", "Onboarding.infoFirst", fallback: "Присоединяйтесь и откройте новый мир уникальных NFT для коллекционеров")
        /// Пополняйте свою коллекцию эксклюзивными картинками, созданными нейросетью!
        internal static let infoSecond = L10n.tr("Localizable", "Onboarding.infoSecond", fallback: "Пополняйте свою коллекцию эксклюзивными картинками, созданными нейросетью!")
        /// Смотрите статистику других и покажите всем, что у вас самая ценная коллекция
        internal static let infoThird = L10n.tr("Localizable", "Onboarding.infoThird", fallback: "Смотрите статистику других и покажите всем, что у вас самая ценная коллекция")
        /// Исследуйте
        internal static let titleFirst = L10n.tr("Localizable", "Onboarding.titleFirst", fallback: "Исследуйте")
        /// Коллекционируйте
        internal static let titleSecond = L10n.tr("Localizable", "Onboarding.titleSecond", fallback: "Коллекционируйте")
        /// Состязайтесь
        internal static let titleThird = L10n.tr("Localizable", "Onboarding.titleThird", fallback: "Состязайтесь")
    }
    internal enum Payment {
        /// Вернуться в каталог
        internal static let backToCatalogueText = L10n.tr("Localizable", "Payment.backToCatalogueText", fallback: "Вернуться в каталог")
        /// Отмена
        internal static let cancelText = L10n.tr("Localizable", "Payment.cancelText", fallback: "Отмена")
        /// Не удалось произвести оплату
        internal static let errorText = L10n.tr("Localizable", "Payment.errorText", fallback: "Не удалось произвести оплату")
        /// ОК
        internal static let okText = L10n.tr("Localizable", "Payment.okText", fallback: "ОК")
        /// Повторить
        internal static let retryText = L10n.tr("Localizable", "Payment.retryText", fallback: "Повторить")
        /// Успех! Оплата прошла, поздравляем с покупкой!
        internal static let successText = L10n.tr("Localizable", "Payment.successText", fallback: "Успех! Оплата прошла, поздравляем с покупкой!")
    }
    internal enum Tab {
        /// Каталог
        internal static let catalog = L10n.tr("Localizable", "Tab.catalog", fallback: "Каталог")
    }
    internal enum Tabbar {
        /// Корзина
        internal static let cartTitle = L10n.tr("Localizable", "Tabbar.cartTitle", fallback: "Корзина")
        /// Каталог
        internal static let catalogTitle = L10n.tr("Localizable", "Tabbar.catalogTitle", fallback: "Каталог")
    }
    internal enum Cart {
        /// Вернуться
        internal static let backButtonText = L10n.tr("Localizable", "cart.backButtonText", fallback: "Вернуться")
        /// К оплате
        internal static let buttonText = L10n.tr("Localizable", "cart.ButtonText", fallback: "К оплате")
        /// Закрыть
        internal static let closeButtonText = L10n.tr("Localizable", "cart.closeButtonText", fallback: "Закрыть")
        /// Удалить
        internal static let deleteButtonText = L10n.tr("Localizable", "cart.deleteButtonText", fallback: "Удалить")
        /// Вы уверены, что хотите удалить объект из корзины?
        internal static let deleteConfirmText = L10n.tr("Localizable", "cart.deleteConfirmText", fallback: "Вы уверены, что хотите удалить объект из корзины?")
        /// Корзина пуста
        internal static let emptyCart = L10n.tr("Localizable", "cart.emptyCart", fallback: "Корзина пуста")
        /// Ошибка загрузки, попробуйте еще раз
        internal static let loadDataErrorText = L10n.tr("Localizable", "cart.loadDataErrorText", fallback: "Ошибка загрузки, попробуйте еще раз")
        /// Цена
        internal static let priceLabel = L10n.tr("Localizable", "cart.priceLabel", fallback: "Цена")
    }
    internal enum CartFilterAlert {
        /// По названию
        internal static let name = L10n.tr("Localizable", "cartFilterAlert.name", fallback: "По названию")
        /// По цене
        internal static let price = L10n.tr("Localizable", "cartFilterAlert.price", fallback: "По цене")
        /// По рейтингу
        internal static let rating = L10n.tr("Localizable", "cartFilterAlert.rating", fallback: "По рейтингу")
        /// Сортировка
        internal static let title = L10n.tr("Localizable", "cartFilterAlert.title", fallback: "Сортировка")
    }
    internal enum Currency {
        /// Пользовательского соглашения
        internal static let cartUserAgreementLinkText = L10n.tr("Localizable", "currency.cartUserAgreementLinkText", fallback: "Пользовательского соглашения")
        /// Совершая покупку, вы соглашаетесь с условиями
        internal static let cartUserAgreementText = L10n.tr("Localizable", "currency.cartUserAgreementText", fallback: "Совершая покупку, вы соглашаетесь с условиями")
        /// Оплатить
        internal static let paymentConfirmButtonText = L10n.tr("Localizable", "currency.paymentConfirmButtonText", fallback: "Оплатить")
        /// Выберите способ оплаты
        internal static let paymentTypeText = L10n.tr("Localizable", "currency.paymentTypeText", fallback: "Выберите способ оплаты")
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
