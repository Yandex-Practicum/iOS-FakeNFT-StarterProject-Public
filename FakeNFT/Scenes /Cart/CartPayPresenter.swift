//
//  CartPayPresenter.swift
//  FakeNFT
//
//  Created by Александр Акимов on 02.05.2024.
//

import UIKit

protocol CartPayPresenterProtocol {
    var visibleCurrencies: [Currencies] { get set }
    var view: CartPayViewControllerProtocol? { get set }
    func fetchCurrenciesAndUpdate() -> [Currencies]
    func viewDidLoad()
}

final class CartPayPresenter: CartPayPresenterProtocol {

    weak var view: CartPayViewControllerProtocol?

    var visibleCurrencies: [Currencies] = []

    private let networkClient: DefaultNetworkClient

    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }

    func viewDidLoad() {

    }

    func fetchCurrenciesAndUpdate() -> [Currencies] {
        self.getCollection { [weak self] cartItems in
            guard let self = self else { return }
            self.visibleCurrencies = cartItems
        }
        view?.updateTable()
        return visibleCurrencies
    }

    func getCollection(completion: @escaping ([Currencies]) -> Void) {
        networkClient.send(request: CartPayRequest(), type: [Currencies].self) { [weak self] result in
            switch result {
            case .success(let currencys):
                completion(currencys)
            case .failure(let error):
                print("Error fetching NFT collection: \(error)")
                completion([])
            }
        }
    }
}
