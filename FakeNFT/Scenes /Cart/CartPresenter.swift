//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Александр Акимов on 24.04.2024.
//

import UIKit

protocol CartPresenterProtocol {
    var visibleNft: [Nft] { get set }
    var view: CartViewControllerProtocol? { get set }
    var sortType: SortType { get set }
    func viewDidLoad()
    func sortCatalog()
}

enum SortType {
    case none
    case byName
    case byPrice
    case byRating
}

final class CartPresenter: CartPresenterProtocol {

    weak var view: CartViewControllerProtocol?
    var mock: [Nft] = [
        Nft(id: "1",
            createdAt: "2",
            name: "April",
            images: [],
            rating: 2,
            description: "kdkkdd",
            price: 3.03,
            author: ""),

        Nft(id: "1",
            createdAt: "23",
            name: "November",
            images: [],
            rating: 4,
            description: "sfrwfwrf",
            price: 2.5,
            author: "")
    ]

    var sortType: SortType = {
        let type = UserDefaults.standard.string(forKey: "CartSorted")
        switch type {
        case "byName":
            return .byName
        case "byPrice":
            return .byPrice
        case "byRating":
            return .byRating
        default:
            return .none
        }
    }()

    var visibleNft: [Nft] = []

    func viewDidLoad() {
        visibleNft = mock
        sortCatalog()
    }

    func sortCatalog() {
        sortType = {
            let type = UserDefaults.standard.string(forKey: "CartSorted")
            switch type {
            case "byName":
                return .byName
            case "byPrice":
                return .byPrice
            case "byRating":
                return .byRating
            default:
                return .none
            }
        }()
        switch sortType {
        case .none:
            break
        case .byName:
            visibleNft.sort { $0.name < $1.name }
            view?.updateTable()
        case .byPrice:
            visibleNft.sort { $0.price > $1.price }
            view?.updateTable()
        case .byRating:
            visibleNft.sort { $0.rating > $1.rating }
            view?.updateTable()
        }
    }
}
