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
              completion: @escaping LoadingCompletionBlock<OrderViewModel>)
}

final class CartOrderSorter: CartOrderSorterProtocol {
    enum SortingTrait {
        case price
        case rating
        case name
    }

    private let sortingQueue = DispatchQueue(label: "com.practicum.yandex.sorting-nft")

    func sort(
        order: OrderViewModel,
        trait: SortingTrait,
        completion: @escaping LoadingCompletionBlock<OrderViewModel>
    ) {
        let sortingClosure = self.getSortingClosure(trait: trait)
        self.sortingQueue.sync {
            let sortedOrder = order.sorted(by: sortingClosure)
            DispatchQueue.main.async {
                completion(sortedOrder)
            }
        }
    }
}

private extension CartOrderSorter {
    func getSortingClosure(trait: SortingTrait) -> (NFTCartCellViewModel, NFTCartCellViewModel) -> Bool {
        switch trait {
        case .name:
            return { $0.name < $1.name }
        case .price:
            return { $0.price < $1.price }
        case .rating:
            return { $0.rating < $1.rating }
        }
    }
}
