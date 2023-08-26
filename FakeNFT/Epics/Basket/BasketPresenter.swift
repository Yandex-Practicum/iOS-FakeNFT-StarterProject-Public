//
//  BasketPresenter.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 21/08/2023.
//

import Foundation

class BasketPresenter {
    private weak var view: BasketView?
    private var nfts: [NftModel]
    private let basketService: BasketService
    private let sortService: SortService
    private let orderService: OrderService
    
    init(view: BasketView) {
        self.view = view
        view.showHud()
        
        nfts = []
        basketService = BasketService.shared
        sortService = SortService.shared
        orderService = OrderService.shared
        
        loadOrder()
//        OrderService.shared.updateOrder(with: ["92", "91", "93", "94", "95"]) {result in
//            switch result {
//            case .success(_):
//                print("added successfully")
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    func loadOrder() {
        orderService.getNFTModels { nfts in
            if let nfts = nfts {
                self.basketService.basket = nfts
            } else {
                print("Error with handling nfts")
                self.basketService.basket = []
            }
            
            self.loadBasket()
            self.view?.removeHud()
        }
    }

    func loadBasket() {
        nfts = basketService.basket
        let currentSortType = sortService.sortingType
        sortNfts(by: currentSortType)
        
        let totalAmount = nfts.count
        let totalPrice = nfts.reduce(0.0) { $0 + $1.price }
        
        view?.updateNfts(nfts)
        view?.changeSumText(totalAmount: totalAmount, totalPrice: totalPrice)
        view?.showEmptyLabel(nfts.isEmpty)
    }
    
    func sortNfts(by value: Sort) {
        sortService.sortingType = value
        let sortedNfts = applySort(nfts: nfts, by: value)
        nfts = sortedNfts
        view?.updateNfts(nfts)
    }
    
    func removeNFTFromBasket(_ model: NftModel) {
        basketService.removeNFTFromBasket(model)
        loadBasket()
    }
    
    private func applySort(nfts: [NftModel], by value: Sort) -> [NftModel] {
        switch value {
        case .price:
            return nfts.sorted(by: { $0.price < $1.price })
        case .rating:
            return nfts.sorted(by: { $0.rating < $1.rating })
        case .name:
            return nfts.sorted(by: { $0.name < $1.name })
        }
    }
}
