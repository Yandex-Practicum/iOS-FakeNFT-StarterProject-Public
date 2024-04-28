//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Александр Акимов on 24.04.2024.
//

import UIKit

protocol CartPresenterProtocol {
    var mock: [Nft] { get set }
    var view: CartViewControllerProtocol? { get set }
    var sortType: SortType { get set }
    func viewDidLoad()
    func configureCell(for cell: CustomCellViewCart, with indexPath: IndexPath)
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

    var sortType: SortType = .byName

    var visibleNft: [Nft] = []

    func viewDidLoad() {
        visibleNft = mock
        sortCatalog()
    }

    func configureCell(for cell: CustomCellViewCart, with indexPath: IndexPath) {
        let data = visibleNft[indexPath.row]
        cell.initCell(nameLabel: data.name, priceLabel: data.price, rating: data.rating)
    }

    func sortCatalog() {
        switch sortType {
        case .none:
            break
        case .byName:
            visibleNft.sort { $0.name < $1.name }
            view?.tableView.reloadData()
        case .byPrice:
            visibleNft.sort { $0.price > $1.price }
            view?.tableView.reloadData()
        case .byRating:
            visibleNft.sort { $0.rating > $1.rating }
            view?.tableView.reloadData()
        }
    }
}
