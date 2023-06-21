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
//        CartRow(imageName: "MockCard1", nftName: "Test 1", rate: 1, price: 3.87, coinName: "ETF"),
//        CartRow(imageName: "MockCard2", nftName: "Test 2", rate: 3, price: 5.55, coinName: "BTC"),
//        CartRow(imageName: "MockCard3", nftName: "Test 3", rate: 5, price: 9.86, coinName: "ETF"),
//        CartRow(imageName: "MockCard1", nftName: "Test 1", rate: 1, price: 3.87, coinName: "ETF"),
//        CartRow(imageName: "MockCard2", nftName: "Test 2", rate: 3, price: 5.55, coinName: "BTC"),
//        CartRow(imageName: "MockCard3", nftName: "Test 3", rate: 5, price: 9.86, coinName: "ETF")
    ]
    
    // for manual testing only
    func delete() {
        visibleRows = visibleRows.count > 0 ? visibleRows.dropLast() : visibleRows
    }
    // for manual testing only
    func add() {
        visibleRows.append(CartRow(imageName: "MockCard\(Int.random(in: 1...3))", nftName: "Test\(Int.random(in: 0...99))", rate: Int.random(in: 0...5), price: Double.random(in: 0...100), coinName: "ETF"))
    }
    
    var mock: [CartRow] = [
        CartRow(imageName: "MockCard1", nftName: "Test 1", rate: 1, price: 3.87, coinName: "ETF"),
        CartRow(imageName: "MockCard2", nftName: "Test 2", rate: 3, price: 5.55, coinName: "BTC"),
        CartRow(imageName: "MockCard3", nftName: "Test 3", rate: 5, price: 9.86, coinName: "ETF"),
        CartRow(imageName: "MockCard1", nftName: "Test 1", rate: 1, price: 3.87, coinName: "ETF"),
        CartRow(imageName: "MockCard2", nftName: "Test 2", rate: 3, price: 5.55, coinName: "BTC"),
        CartRow(imageName: "MockCard3", nftName: "Test 3", rate: 5, price: 9.86, coinName: "ETF")
    ]
}
