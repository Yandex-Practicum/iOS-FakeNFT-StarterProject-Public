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
    var priceCart: Double? { get set }
    func editOrder(typeOfEdit: EditType, nftId: String, completion: @escaping (Error?) -> Void)
    func sortCatalog()
    func getAllCartData()
}

enum SortType {
    case none
    case byName
    case byPrice
    case byRating
}

enum EditType {
    case addNft
    case deleteNft
}

final class CartPresenter: CartPresenterProtocol {

    weak var view: CartViewControllerProtocol?

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
    var cart: Cart?
    var visibleNft: [Nft] = []
    var priceCart: Double?

    private let networkClient: DefaultNetworkClient

    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }

    func getAllCartData() {
        view?.startLoading()
        cart = nil
        visibleNft = []
        priceCart = 0
        getCart { [weak self] cartItem in
            guard let self = self, let cartItem = cartItem else { return }
            self.saveCart(cart: cartItem)
            if cartItem.nfts.isEmpty && cartItem.nfts.count == 0 {
                view?.showEmptyMessage()
                visibleNft = []
                view?.updateTable()
                self.view?.stopLoading()
                return
            } else {
                view?.hideEmptyMessage()
            }
            self.getNftsCart(cart: cartItem.nfts) {
                DispatchQueue.main.async {
                    self.view?.updateNftsCount()
                    self.sortCatalog()
                    self.view?.updateTable()
                }
                self.view?.stopLoading()
            }
        }
    }

    func editOrder(typeOfEdit: EditType, nftId: String, completion: @escaping (Error?) -> Void) {
        getCart { [weak self] cartItem in
            guard let self = self, let cartItem = cartItem else { return }
            var items = cartItem.nfts
            if typeOfEdit == .addNft {
                items.append(nftId)
            } else {
                if let index = items.firstIndex(of: nftId) {
                    items.remove(at: index)
                } else {
                    return
                }
            }
            sendNewOrder(nftsIds: items) { _ in
                self.getAllCartData()
            }
        }
    }

    private func sendNewOrder(nftsIds: [String], completion: @escaping (Error?) -> Void) {
        let nftsString = nftsIds.joined(separator: ",")
        let bodyString = "nfts=\(nftsString)"
        guard let bodyData = bodyString.data(using: .utf8) else { return }

        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("9db803ac-6777-4dc6-9be2-d8eaa53129a9", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        if nftsIds.count != 0 {
            request.httpBody = bodyData
        }

        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
        task.resume()

    }

    private func getNftsCart(cart: [String], completion: @escaping () -> Void) {
        let group = DispatchGroup()
        cart.forEach {
            group.enter()
            self.networkClient.send(request: CartGetNftsRequest(nftId: $0), type: Nft.self) { [weak self] result in
                defer {
                    group.leave()
                }
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    priceCart = (priceCart ?? 0) + nft.price
                    self.visibleNft.append(nft)
                case .failure(let error):
                    print("Error fetching NFT collection: \(error)")
                }
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }

    private func getCart(completion: @escaping (Cart?) -> Void) {
        networkClient.send(request: CartRequest(), type: Cart.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cart):
                DispatchQueue.main.async {
                    completion(cart)
                }
            case .failure(let error):
                print("Error fetching NFT collection: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
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
                return .byName
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

    private func saveCart(cart: Cart) {
        self.cart = cart
    }
}
