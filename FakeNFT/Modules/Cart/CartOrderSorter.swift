//
//  CartOrderSorter.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 04.08.2023.
//

import Foundation

protocol CartOrderSorterProtocol {
    func sort(order: OrderViewModel,
              trait: CartOrderSorter.SortingTrait,
              completion: @escaping ((OrderViewModel) -> Void))
}

final class CartOrderSorter: CartOrderSorterProtocol {
    enum SortingTrait {
        case price
        case rating
        case name
    }

    private let sortingQueue = DispatchQueue(label: "com.practicum.yandex.sort-nft")

    func sort(
        order: OrderViewModel,
        trait: SortingTrait,
        completion: @escaping ((OrderViewModel) -> Void)
    ) {
        let sortClosure: (NFTCartCellViewModel, NFTCartCellViewModel) -> Bool

        switch trait {
        case .name:
            sortClosure = { $0.name < $1.name }
        case .price:
            sortClosure = { $0.price < $1.price }
        case .rating:
            sortClosure = { $0.rating < $1.rating }
        }

        self.sortingQueue.sync {
            let sortedOrder = order.sorted(by: sortClosure)
            DispatchQueue.main.async {
                completion(sortedOrder)
            }
        }
    }
}
