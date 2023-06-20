//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import Foundation

final class CartViewModel {
    // TODO: move to DataStore
    @Observable private (set) var visibleRows: [CartRow] = [
        CartRow(imageName: "MockCard1", nftName: "Test 1", rate: 1, price: 3.87, coinName: "ETF"),
        CartRow(imageName: "MockCard2", nftName: "Test 2", rate: 3, price: 5.55, coinName: "BTC"),
        CartRow(imageName: "MockCard3", nftName: "Test 3", rate: 5, price: 9.86, coinName: "ETF"),
        CartRow(imageName: "MockCard1", nftName: "Test 1", rate: 1, price: 3.87, coinName: "ETF"),
        CartRow(imageName: "MockCard2", nftName: "Test 2", rate: 3, price: 5.55, coinName: "BTC"),
        CartRow(imageName: "MockCard3", nftName: "Test 3", rate: 5, price: 9.86, coinName: "ETF")
    ]
}
