import Foundation

enum Screens: String {
    // Catalog screens:
    case catalogMain = "CatalogMain"
    case catalogCollection = "CatalogCollection"
    case catalogAboutAuthor = "CatalogAboutAuthor"
    case nftCard = "CatalogNFTCard"
    case catalogAboutAuthorFromNFTCard = "CatalogAboutAuthorFromNFTCard"
    case aboutCurrency = "CatalogAboutCurrency"
    case browsingNFTCard = "CatalogBrowsingNFTCard"

    // Cart screens:
    case cartMain = "CartMain"

    // Profile screens:
    case profileMain = "ProfileMain"

    // Statistic screens:
    case statisticMain = "StatisticMain"
    case statisticProfile = "StatisticProfile"
    case statisticСollectionNFT = "StatisticСollectionNFT"

    // Auth screens
    case authMain = "authMain"
    case authRegistration = "authRegistration"
    case authDemo = "authDemo"
    case onboardingMain = "onboardingMain"
}

enum Items: String {
    case screen = "Screen"
    case collectionCell = "CollectionCell"
    case tableViewCell = "TableViewCell"
    case buttonSorting = "ButtonSorting"
    case buttonSortingByName = "ButtonSortingByName"
    case buttonSortingByRating = "ButtonSortingByRating"
    case buttonSortingByTitle = "buttonSortingByTitle"
    case buttonSortingByNumber = "buttonSortingByNumber"
    case buttonSortingByPrice = "buttonSortingByPrice"
    case buttonGoToUserSite = "ButtonGoToUserSite"
    case buttonGoToUserCollection = "ButtonGoToUserCollection"
    case buttonAddToCard = "ButtonAddToCard"
    case buttonLike = "ButtonLike"
    case buttonDemo = "buttonDemo"
    case buttonRegistration = "buttonRegistration"
    case pullToRefresh = "PullToRefresh"
    case swipeNFTCard = "SwipeNFTCard"
    case scaleNFTCard = "ScaleNFTCard"
    case authorization = "authorization"
    case registration = "registration"
}

enum Events: String {
    case click = "Click"
    case open = "Open"
    case close = "Close"
    case pull = "Pull"
    case success = "success"
    case unsuccess = "unsuccess"
}

final class AnalyticsService {

    static let instance = AnalyticsService()

    private init() {}

    func sentEvent(screen: Screens, item: Items, event: Events) {
        var parameters: [AnyHashable: Any] = [:]
        parameters = [item.rawValue: event.rawValue]

        }
    }

