//
//  MyNFTsPresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 24.01.2026.
//

import Foundation

protocol MyNFTsPresenterProtocol: AnyObject {
    func didTapBack()
    func viewDidLoad()
    func didTapSort()
    func didSelectSortOption(_ option: Sorting)
}

final class MyNFTsPresenter: MyNFTsPresenterProtocol {
    
    weak var view: MyNFTsViewProtocol?
    
    func viewDidLoad() {
        // TODO: загрузить NFT пользователя и применить сохранённую сортировку
    }
    
    func didTapBack() {
        view?.closeScreen()
    }
    
    func didTapSort() {
        let options: [Sorting] = [.price, .rating, .name]
        view?.showSortAlert(options: options)
    }
    
    func didSelectSortOption(_ option: Sorting) {
        print("Выбрана сортировка: \(option.title)")
    }
}
