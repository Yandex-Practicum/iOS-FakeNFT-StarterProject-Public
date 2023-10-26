//
//  SortStorage.swift
//  FakeNFT
//
//  Created by Leo Bonhart on 25.10.2023.
//

import Foundation

final class MyNftSortStorage: MyNftSortStorageProtocol {

    // MARK: - Properties
    private let storage = UserDefaults.standard
    private let sortingKey = "sortingKey"

    // MARK: - Methods
    func saveSorting(_ sortingOption: SortingOption) {
        storage.set(sortingOption.sortingOptions, forKey: sortingKey)
    }

    func fetchSorting() -> SortingOption? {
        if let sortingOptionAsString = storage.object(forKey: sortingKey) as? String {
            if let sortingOption = SortingOption(stringValue: sortingOptionAsString) {
                return sortingOption
            }
        }
        return nil
    }
}
