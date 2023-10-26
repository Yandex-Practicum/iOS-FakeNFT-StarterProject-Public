import UIKit

enum SortingOption: CaseIterable {
    case byName
    case byRating
    case byTitle
    case byPrice
    case byQuantity
    case close
    
    var localizedString: String {
        switch self {
        case .byName:
            return NSLocalizedString("sorting.byName", tableName: "Localizable", comment: "sorting by name")
        case .byRating:
            return NSLocalizedString("sorting.byRating", tableName: "Localizable", comment: "sorting by Rating")
        case .byTitle:
            return NSLocalizedString("sorting.byTitle", tableName: "Localizable", comment: "sorting by Title")
        case .byPrice:
            return NSLocalizedString("sorting.byPrice", tableName: "Localizable", comment: "sorting by Price")
        case .byQuantity:
            return NSLocalizedString("sorting.byQuantity", tableName: "Localizable", comment: "sorting by Quantity")
        case .close:
            return NSLocalizedString("general.close", tableName: "Localizable", comment: "Close")
        }
    }
    
    var sortingOptions: String {
        switch self {
        case .byName:
            return "byName"
        case .byRating:
            return "byRating"
        case .byTitle:
            return "byTitle"
        case .byPrice:
            return "byPrice"
        case .byQuantity:
            return "byQuantity"
        default:
            return ""
        }
    }
    
    init?(stringValue: String) {
        switch stringValue {
        case "byName":
            self = .byName
        case "byRating":
            self = .byRating
        case "byTitle":
            self = .byTitle
        case "byPrice":
            self = .byPrice
        case "byQuantity":
            self = .byQuantity
        default:
            return nil
        }
    }
}

protocol AlertServiceProtocol {
    func showActionSheet(title: String?, sortingOptions: [SortingOption], on viewController: UIViewController, completion: @escaping (SortingOption) -> Void)
}

final class UniversalAlertService: AlertServiceProtocol {
    func showActionSheet(title: String?, sortingOptions: [SortingOption], on viewController: UIViewController, completion: @escaping (SortingOption) -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for option in sortingOptions {
            if option == .close {
                
                let action = UIAlertAction(title: option.localizedString, style: .cancel) { _ in
                    completion(option)
                }
                alertController.addAction(action)
            } else {
                let action = UIAlertAction(title: option.localizedString, style: .default) { _ in
                    completion(option)
                }
                alertController.addAction(action)
            }
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}
