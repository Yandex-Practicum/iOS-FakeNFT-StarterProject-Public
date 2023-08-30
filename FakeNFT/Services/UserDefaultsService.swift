import Foundation

enum SortScreen: String {
    case profile
    case catalog
    case cart
    case statistic
}

class UserDefaultsService {
    
    static let shared = UserDefaultsService()
    
    private init() {}
    
    func saveSortingOption(_ option: SortingOption, forScreen screen: SortScreen) {
        UserDefaults.standard.set(option.sortingOptions, forKey: screen.rawValue)
       }
    
    func getSortingOption(for screen: SortScreen) -> SortingOption? {
        if let rawValue = UserDefaults.standard.value(forKey: screen.rawValue) as? String,
           let option = SortingOption(stringValue: rawValue) {
            return option
        }
        return nil
    }
}
