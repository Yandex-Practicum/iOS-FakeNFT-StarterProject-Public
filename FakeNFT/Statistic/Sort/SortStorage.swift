//
//  SortStorage.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/19/25.
//
import Foundation

final class SortStorage {
    static let shared = SortStorage()
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case selectedSort
    }
    
    var selectedSort: SortCases? {
        get {
            guard let selectedSort = userDefaults.string(forKey: Keys.selectedSort.rawValue) else {
                return nil
            }
            
            return SortCases(rawValue: selectedSort)
        }
        set {
            userDefaults.set(newValue?.rawValue, forKey: Keys.selectedSort.rawValue)
        }
    }
}
