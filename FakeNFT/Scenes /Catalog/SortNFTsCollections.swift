import Foundation

enum SortNFTsCollectionType: String {
    case byName
    case byNFTsCount
}

final class SortNFTsCollections {
    private let userDefaults = UserDefaults.standard
    
    func getSortValue() -> String {
        guard let sort = userDefaults.string(forKey: "Sort") else { return "" }
        return sort
    }
    
    func setSortValue(value: String) {
        userDefaults.set(value, forKey: "Sort")
    }
}
