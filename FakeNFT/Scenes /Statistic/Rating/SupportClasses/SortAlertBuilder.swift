//
//  SortAlertPresenter.swift
//  FakeNFT
//
//  Created by macOS on 26.06.2023.
//

import UIKit

final class SortAlertBuilder {
    
    private init() {}
    
    static func buildSortAlert(
        onNameSort: @escaping () -> Void,
        onRatingSort: @escaping () -> Void) -> UIAlertController {
            let sortAlertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
            
            sortAlertController.addAction(UIAlertAction(title: "По имени", style: .default) { _ in
                onNameSort()
            })
            sortAlertController.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
                onRatingSort()
            })
            sortAlertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            
            return sortAlertController
        }
}
