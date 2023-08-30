// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Alert {
    internal enum Authorization {
      /// Не удалось войти в систему
      internal static let message = L10n.tr("Localizable", "alert.authorization.message", fallback: "Не удалось войти в систему")
      /// Что-то пошло не так (
      internal static let title = L10n.tr("Localizable", "alert.authorization.title", fallback: "Что-то пошло не так (")
    }
  }
  internal enum Authorization {
    /// Демо
    internal static let demo = L10n.tr("Localizable", "authorization.demo", fallback: "Демо")
    /// Вход
    internal static let enter = L10n.tr("Localizable", "authorization.enter", fallback: "Вход")
    /// Войти
    internal static let entering = L10n.tr("Localizable", "authorization.entering", fallback: "Войти")
    /// Забыли пароль?
    internal static let forgetPassword = L10n.tr("Localizable", "authorization.forgetPassword", fallback: "Забыли пароль?")
    /// Пароль
    internal static let password = L10n.tr("Localizable", "authorization.password", fallback: "Пароль")
    /// Регистрация
    internal static let registrate = L10n.tr("Localizable", "authorization.registrate", fallback: "Регистрация")
    /// Зарегистрироваться
    internal static let registration = L10n.tr("Localizable", "authorization.registration", fallback: "Зарегистрироваться")
    internal enum Error {
      /// Данное имя пользователя занято
      internal static let loginIsBusy = L10n.tr("Localizable", "authorization.error.loginIsBusy", fallback: "Данное имя пользователя занято")
      /// Введен неверный логин или пароль
      internal static let loginPasswordMistake = L10n.tr("Localizable", "authorization.error.loginPasswordMistake", fallback: "Введен неверный логин или пароль")
      /// Введите email
      internal static let mailMistake = L10n.tr("Localizable", "authorization.error.mailMistake", fallback: "Введите email")
      /// Пароль должен иметь минимум 6 символов
      internal static let passwordMistake = L10n.tr("Localizable", "authorization.error.passwordMistake", fallback: "Пароль должен иметь минимум 6 символов")
    }
  }
  internal enum Basket {
    /// Корзина
    internal static let title = L10n.tr("Localizable", "basket.title", fallback: "Корзина")
  }
  internal enum Cart {
    internal enum MainScreen {
      /// Вы уверены, что хотите удалить объект из корзины?
      internal static let deleteItemAlert = L10n.tr("Localizable", "cart.mainScreen.deleteItemAlert", fallback: "Вы уверены, что хотите удалить объект из корзины?")
      /// Удалить
      internal static let deleteItemButton = L10n.tr("Localizable", "cart.mainScreen.deleteItemButton", fallback: "Удалить")
      /// Корзина пуста
      internal static let emptyCart = L10n.tr("Localizable", "cart.mainScreen.emptyCart", fallback: "Корзина пуста")
      /// Вернуться
      internal static let returnButton = L10n.tr("Localizable", "cart.mainScreen.returnButton", fallback: "Вернуться")
      /// К оплате
      internal static let toPayButton = L10n.tr("Localizable", "cart.mainScreen.toPayButton", fallback: "К оплате")
    }
    internal enum PayScreen {
      /// Оплатить
      internal static let payButton = L10n.tr("Localizable", "cart.payScreen.payButton", fallback: "Оплатить")
      /// Выберите способ оплаты
      internal static let paymentChoice = L10n.tr("Localizable", "cart.payScreen.paymentChoice", fallback: "Выберите способ оплаты")
      /// Совершая покупку, вы соглашаетесь с условиями
      internal static let userTerms = L10n.tr("Localizable", "cart.payScreen.userTerms", fallback: "Совершая покупку, вы соглашаетесь с условиями")
      /// Пользовательского соглашения
      internal static let userTermsLink = L10n.tr("Localizable", "cart.payScreen.userTermsLink", fallback: "Пользовательского соглашения")
    }
    internal enum SuccessfulPayment {
      /// Успех! Оплата прошла, поздравляем с покупкой!
      internal static let successful = L10n.tr("Localizable", "cart.successfulPayment.successful", fallback: "Успех! Оплата прошла, поздравляем с покупкой!")
      /// Вернуться в каталог
      internal static let toBackCatalogButton = L10n.tr("Localizable", "cart.successfulPayment.toBackCatalogButton", fallback: "Вернуться в каталог")
    }
    internal enum UnsuccessfulPayment {
      /// Попробовать еще раз
      internal static let tryAgain = L10n.tr("Localizable", "cart.unsuccessfulPayment.tryAgain", fallback: "Попробовать еще раз")
      /// Упс! Что-то пошло не так :(
      ///  Попробуйте ещё раз!
      internal static let unsuccessful = L10n.tr("Localizable", "cart.unsuccessfulPayment.unsuccessful", fallback: "Упс! Что-то пошло не так :(\n Попробуйте ещё раз!")
    }
  }
  internal enum Catalog {
    /// Каталог
    internal static let title = L10n.tr("Localizable", "catalog.title", fallback: "Каталог")
    internal enum CurrentCollection {
      /// Автор коллекции
      internal static let author = L10n.tr("Localizable", "catalog.currentCollection.author", fallback: "Автор коллекции")
    }
    internal enum NftCard {
      internal enum Button {
        /// Добавить в корзину
        internal static let addToCart = L10n.tr("Localizable", "catalog.nftCard.button.addToCart", fallback: "Добавить в корзину")
        /// Перейти на сайт продавца
        internal static let goToSellerSite = L10n.tr("Localizable", "catalog.nftCard.button.goToSellerSite", fallback: "Перейти на сайт продавца")
        /// Удалить из корзины
        internal static let removeFromCart = L10n.tr("Localizable", "catalog.nftCard.button.removeFromCart", fallback: "Удалить из корзины")
      }
    }
  }
  internal enum General {
    /// Отменить
    internal static let cancel = L10n.tr("Localizable", "general.cancel", fallback: "Отменить")
    /// Закрыть
    internal static let close = L10n.tr("Localizable", "general.close", fallback: "Закрыть")
    /// Удалить
    internal static let delete = L10n.tr("Localizable", "general.delete", fallback: "Удалить")
    /// OK
    internal static let ok = L10n.tr("Localizable", "general.OK", fallback: "OK")
    /// Цена
    internal static let price = L10n.tr("Localizable", "general.price", fallback: "Цена")
    /// Вернуться
    internal static let `return` = L10n.tr("Localizable", "general.return", fallback: "Вернуться")
  }
  internal enum NetworkError {
    /// Не удалось получить данные, попробуйте позже
    internal static let anotherError = L10n.tr("Localizable", "networkError.anotherError", fallback: "Не удалось получить данные, попробуйте позже")
    /// Не удалось конвертировать полученные данные
    internal static let parsingError = L10n.tr("Localizable", "networkError.parsingError", fallback: "Не удалось конвертировать полученные данные")
    /// Ошибка выполнения запроса
    internal static let requestError = L10n.tr("Localizable", "networkError.requestError", fallback: "Ошибка выполнения запроса")
    /// Попробуйте позже
    internal static let tryLater = L10n.tr("Localizable", "networkError.tryLater", fallback: "Попробуйте позже")
    /// Проверьте интернет - соединение
    internal static let urlSessionError = L10n.tr("Localizable", "networkError.URLSessionError", fallback: "Проверьте интернет - соединение")
    internal enum Http {
      /// По запросу ничего не найдено
      internal static let _404 = L10n.tr("Localizable", "networkError.http.404", fallback: "По запросу ничего не найдено")
      /// Ошибка обновления ресурса
      internal static let _409 = L10n.tr("Localizable", "networkError.http.409", fallback: "Ошибка обновления ресурса")
      /// Запрошенный ресурс больше недоступен
      internal static let _410 = L10n.tr("Localizable", "networkError.http.410", fallback: "Запрошенный ресурс больше недоступен")
      /// Ошибка на стороне сервера
      internal static let _5Хх = L10n.tr("Localizable", "networkError.http.5хх", fallback: "Ошибка на стороне сервера")
    }
  }
  internal enum Onboarding {
    /// Коллекционируйте
    internal static let collect = L10n.tr("Localizable", "onboarding.collect", fallback: "Коллекционируйте")
    /// Состязайтесь
    internal static let competit = L10n.tr("Localizable", "onboarding.competit", fallback: "Состязайтесь")
    /// Что внутри?
    internal static let isWhatInside = L10n.tr("Localizable", "onboarding.isWhatInside", fallback: "Что внутри?")
    /// Исследуйте
    internal static let research = L10n.tr("Localizable", "onboarding.research", fallback: "Исследуйте")
    internal enum Collect {
      /// Пополняйте свою коллекцию эксклюзивными картинками, созданными нейросетью!
      internal static let text = L10n.tr("Localizable", "onboarding.collect.text", fallback: "Пополняйте свою коллекцию эксклюзивными картинками, созданными нейросетью!")
    }
    internal enum Competit {
      /// Смотрите статистику других и покажите всем, что у вас самая ценная коллекция
      internal static let text = L10n.tr("Localizable", "onboarding.competit.text", fallback: "Смотрите статистику других и покажите всем, что у вас самая ценная коллекция")
    }
    internal enum Research {
      /// Присоединяйтесь и откройте новый мир уникальных NFT для коллекционеров
      internal static let text = L10n.tr("Localizable", "onboarding.research.text", fallback: "Присоединяйтесь и откройте новый мир уникальных NFT для коллекционеров")
    }
  }
  internal enum Profile {
    /// Профиль
    internal static let title = L10n.tr("Localizable", "profile.title", fallback: "Профиль")
    internal enum EditScreen {
      /// Сменить фото
      internal static let changePhoto = L10n.tr("Localizable", "profile.editScreen.changePhoto", fallback: "Сменить фото")
      /// Описание
      internal static let description = L10n.tr("Localizable", "profile.editScreen.description", fallback: "Описание")
      /// Имя
      internal static let name = L10n.tr("Localizable", "profile.editScreen.name", fallback: "Имя")
      /// Cайт
      internal static let site = L10n.tr("Localizable", "profile.editScreen.site", fallback: "Cайт")
    }
    internal enum FavouritesNFT {
      /// У Вас еще нет избранных NFT
      internal static let plug = L10n.tr("Localizable", "profile.favouritesNFT.plug", fallback: "У Вас еще нет избранных NFT")
    }
    internal enum MainScreen {
      /// О разработчике
      internal static let aboutDeveloper = L10n.tr("Localizable", "profile.mainScreen.aboutDeveloper", fallback: "О разработчике")
      /// Избранные NFT
      internal static let favouritesNFT = L10n.tr("Localizable", "profile.mainScreen.favouritesNFT", fallback: "Избранные NFT")
      /// Мои NFT
      internal static let myNFT = L10n.tr("Localizable", "profile.mainScreen.myNFT", fallback: "Мои NFT")
    }
    internal enum MyNFT {
      /// От
      internal static let from = L10n.tr("Localizable", "profile.myNFT.from", fallback: "От")
      /// У Вас еще нет NFT
      internal static let plug = L10n.tr("Localizable", "profile.myNFT.plug", fallback: "У Вас еще нет NFT")
    }
  }
  internal enum Sorting {
    /// По имени
    internal static let byName = L10n.tr("Localizable", "sorting.byName", fallback: "По имени")
    /// По количеству NFT
    internal static let byNFTCount = L10n.tr("Localizable", "sorting.byNFTCount", fallback: "По количеству NFT")
    /// По цене
    internal static let byPrice = L10n.tr("Localizable", "sorting.byPrice", fallback: "По цене")
    /// По рейтингу
    internal static let byRating = L10n.tr("Localizable", "sorting.byRating", fallback: "По рейтингу")
    /// По названию
    internal static let byTitle = L10n.tr("Localizable", "sorting.byTitle", fallback: "По названию")
    /// Сортировка
    internal static let title = L10n.tr("Localizable", "sorting.title", fallback: "Сортировка")
  }
  internal enum Statistic {
    /// Статистика
    internal static let title = L10n.tr("Localizable", "statistic.title", fallback: "Статистика")
    internal enum Profile {
      internal enum ButtonCollection {
        /// Коллекция NFT
        internal static let title = L10n.tr("Localizable", "statistic.profile.buttonCollection.title", fallback: "Коллекция NFT")
      }
      internal enum ButtonUser {
        /// Перейти на сайт пользователя
        internal static let title = L10n.tr("Localizable", "statistic.profile.buttonUser.title", fallback: "Перейти на сайт пользователя")
      }
      internal enum UserCollection {
        /// У пользователя еще нет NFT
        internal static let stub = L10n.tr("Localizable", "statistic.profile.userCollection.stub", fallback: "У пользователя еще нет NFT")
      }
    }
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
