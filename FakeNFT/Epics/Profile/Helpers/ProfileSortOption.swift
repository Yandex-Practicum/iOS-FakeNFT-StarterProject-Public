import Foundation

enum ProfileSortOption: String, StringRepresentableEnum {
    case byPrice
    case byRating
    case byName

    var stringValue: String {
        return self.rawValue
    }
    
    init(rawValue: String) {
        switch rawValue {
        case "byPrice": self = .byPrice
        case "byRating": self = .byRating
        case "byName": self = .byName
        default: self = .byRating
        }
    }
}
