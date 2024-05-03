//
//  StatisticPresenter.swift
//  FakeNFT
//
//  Created by Сергей on 23.04.2024.
//

import Foundation

protocol StatisticsViewPresenterDelegate: AnyObject {
    func set(person: Person)
}

protocol StatisticPresenterProtocol: AnyObject {
    var objects: [Person] { get set }
    var delegate: StatisticsViewPresenterDelegate? { get set }
}

final class StatisticsPresenter: StatisticPresenterProtocol {
    
    weak var delegate: StatisticsViewPresenterDelegate?
    
    var objects: [Person] = [
        Person(name: "Alex", image: "avatar", webSite: "https://ya.ru", rating: 1, nftCount: 112, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", nft: [
        NFTModel(image: "April", name: "April", price: 1.78, isFavourite: false, rating: 3, isAdded: false),
        NFTModel(image: "mockNFT", name: "Zeus", price: 1.98, isFavourite: false, rating: 2, isAdded: false)
    ]),
        Person(name: "Mads", image: "avatar1", webSite: "https://google.com", rating: 2, nftCount: 71, description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", nft: []), Person(name: "Temothee", image: "avatar2", webSite: "https://github.com", rating: 3, nftCount: 51, description: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur", nft: [])]
}


