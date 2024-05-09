//
//  PayPresenter.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 08.05.2024.
//

import Foundation
import UIKit

protocol PayPresenterProtocol {
    var selectedCurrency: CurrencyDataModel? { get set }
    func count() -> Int
    func getModel(indexPath: IndexPath) -> CurrencyDataModel
    func payOrder()
    func getCurrencies()
}

final class PayPresenter: PayPresenterProtocol {

    

    private var payController: PayViewControllerProtocol?
    private var currencies: [CurrencyDataModel] = []
    var selectedCurrency: CurrencyDataModel? {
        didSet {
            if selectedCurrency != nil {
            payController?.didSelectCurrency(isEnable: true)
            }
        }
    }
    
    var mock1 = CurrencyDataModel(title: "Bitcoin", name: "BTC", image: "Bitcoin", id: "1")
    var mock2 = CurrencyDataModel(title: "Tether", name: "USDT", image: "Tether", id: "2")
    
    init(payController: PayViewControllerProtocol) {
        self.payController = payController
        self.currencies = [mock1, mock2]
    }
    func count() -> Int {
        return currencies.count
    }
    
    func getModel(indexPath: IndexPath) -> CurrencyDataModel {
        let model = currencies[indexPath.row]
        return model
    }
    
    func payOrder() {
        payController?.startLoadIndicator()
        guard let selectedCurrency = selectedCurrency else { return }
        
        var result = Int.random(in: 0..<2)
        
        switch result {
            case 1:
            payController?.didPay(payResult: true)
            payController?.stopLoadIndicator()
            case 0:
            payController?.didPay(payResult: false)
            payController?.stopLoadIndicator()
        default:
            print("something werid")
        }
        
        //TODO: реализовать c данными из сети
    }
    
    
    func getCurrencies() {
        payController?.startLoadIndicator()
    }
  
}
