//
//  DataStore.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import Foundation
import Combine

protocol DataStorageProtocol {
    var dataPublisher: AnyPublisher<[CartRow], Never> { get }
    func getCartRowItems() -> [CartRow]
    func deleteItem(with id: UUID?)
}

protocol PaymentMethodStorageProtocol {
    var paymentMethodsPublisher: AnyPublisher<[PaymentMethodRow], Never> { get }
    func getPaymentMethods() -> [PaymentMethodRow]
}

final class DataStore {
    private var storedPublishedItems = CurrentValueSubject<[CartRow], Never>([])
    private var loadedPaymentMethods = CurrentValueSubject<[PaymentMethodRow], Never>([])
    
    var dataPublisher: AnyPublisher<[CartRow], Never> {
        return storedPublishedItems.eraseToAnyPublisher()
    }
    
    var paymentMethodsPublisher: AnyPublisher<[PaymentMethodRow], Never> {
        return loadedPaymentMethods.eraseToAnyPublisher()
    }
    
    private var storedItems: [CartRow] = [
        CartRow(imageName: "MockCard1", nftName: "Test 1", rate: 1, price: 3.87, coinName: "ETF"),
        CartRow(imageName: "MockCard2", nftName: "Test 2", rate: 3, price: 5.55, coinName: "BTC"),
        CartRow(imageName: "MockCard3", nftName: "Test 3", rate: 5, price: 9.86, coinName: "ETF"),
        CartRow(imageName: "MockCard1", nftName: "Test 1", rate: 1, price: 3.87, coinName: "ETF"),
        CartRow(imageName: "MockCard2", nftName: "Test 2", rate: 3, price: 5.55, coinName: "BTC"),
        CartRow(imageName: "MockCard3", nftName: "Test 3", rate: 5, price: 9.86, coinName: "ETF")
    ] {
        didSet {
            sendStoredItemsUpdates(newData: storedItems)
        }
    }
    
    private var loadedMethods: [PaymentMethodRow] = [
        PaymentMethodRow(title: "Tether", name: "USDT", image: "Tether", id: "1"),
        PaymentMethodRow(title: "Bitcoin", name: "BTC", image: "Bitcoin", id: "2"),
        PaymentMethodRow(title: "Dogecoin", name: "DOGE", image: "Dogecoin", id: "3"),
        PaymentMethodRow(title: "Tether", name: "USDT", image: "Tether", id: "4"),
        PaymentMethodRow(title: "Bitcoin", name: "BTC", image: "Bitcoin", id: "5"),
        PaymentMethodRow(title: "Dogecoin", name: "DOGE", image: "Dogecoin", id: "6"),
    ] {
        didSet {
            sendLoadedPaymentMethods(newData: loadedMethods)
        }
    }
    
    private func sendStoredItemsUpdates(newData: [CartRow]) {
        storedPublishedItems.send(newData)
    }
    
    private func sendLoadedPaymentMethods(newData: [PaymentMethodRow]) {
        loadedPaymentMethods.send(newData)
    }
}

extension DataStore: DataStorageProtocol {
    func getCartRowItems() -> [CartRow] {
        return storedItems
    }
    
    func deleteItem(with id: UUID?) {
        guard let id else { return }
        storedItems.removeAll(where: { $0.id == id })
    }
}

extension DataStore: PaymentMethodStorageProtocol {
    func getPaymentMethods() -> [PaymentMethodRow] {
        return loadedMethods
    }
}
