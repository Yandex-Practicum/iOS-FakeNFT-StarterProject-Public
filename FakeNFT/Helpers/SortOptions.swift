import Foundation

enum SortOption {
    case price
    case rating
    case title

    var description: String {
        switch self {
        case .price:
            return NSLocalizedString("SortOptions.price", comment: "")
        case .rating:
            return NSLocalizedString("SortOptions.rate", comment: "")
        case .title:
            return NSLocalizedString("SortOptions.name", comment: "")
        }
    }
}
