//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 10.12.2023.
//

import Foundation

protocol CatalogPresenterProtocol {
    var collectionsNFT: [CatalogNFTCellViewModel] { get }
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    
    // MARK: - Properties
    weak var view: NftCatalogView?
    var collectionsNFT: [CatalogNFTCellViewModel] = custonCollectionsNFT
    
    // MARK: - Init

    init() {
    }
    
    // MARK: - Functions
    
    
    
}


let custonCollectionsNFT: [CatalogNFTCellViewModel] = [
    CatalogNFTCellViewModel(nameNFT: "Peach", countNFT: 12, url: URL(string: "https://practicum.yandex.ru")! ),
    CatalogNFTCellViewModel(nameNFT: "Blue", countNFT: 7, url: URL(string: "https://practicum.yandex.ru")! ),
    CatalogNFTCellViewModel(nameNFT: "Brown", countNFT: 5, url: URL(string: "https://practicum.yandex.ru")! ),
    CatalogNFTCellViewModel(nameNFT: "Peach", countNFT: 12, url: URL(string: "https://practicum.yandex.ru")! ),
]
