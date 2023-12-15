//
//  CollectionNFTPresenter.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 15.12.2023.
//

import UIKit

protocol CollectionPresenterProtocol {
    var collectionCells: [CollectionNFTCellViewModel] { get }
    
}


final class CollectionNFTPresenter: CollectionPresenterProtocol {
    
    
    // MARK: - Properties
    weak var view: NftCatalogView?
    var collectionCells: [CollectionNFTCellViewModel] = custonCollectionCells
    
    // MARK: - Init
    
    init() {
    }
    
    // MARK: - Functions
    
    
}


let custonCollectionCells: [CollectionNFTCellViewModel] = [
    CollectionNFTCellViewModel(nameNFT: "Archi", price: "1", isLiked: true, isInTheBasket: true, rating: 2, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "Ruby", price: "2", isLiked: true, isInTheBasket: true, rating: 5, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "Doritos", price: "11", isLiked: false, isInTheBasket: false, rating: 5, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "Cheatos", price: "12", isLiked: true, isInTheBasket: false, rating: 4, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "lays", price: "13", isLiked: false, isInTheBasket: true, rating: 3, url: URL(string: "https://practicum.yandex.ru")!)
    
]
