import Foundation

final class SortService {
    static let shared = SortService() 
    private let userDefaults = UserDefaults.standard
    private let sortKey = "basketSortKey"
    private init() {}
    
    var sortingType: Sort {
        get {
            guard
                let data = userDefaults.data(forKey: sortKey),
                let sortingType = try? JSONDecoder().decode(Sort.self, from: data) else {
                return Sort.name
            }
            return sortingType
        }
        set {
            guard let encodedData = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(encodedData, forKey: sortKey)
            userDefaults.synchronize()
        }
    }
}

enum Sort: Codable, Equatable {
    case price
    case rating
    case name
}
