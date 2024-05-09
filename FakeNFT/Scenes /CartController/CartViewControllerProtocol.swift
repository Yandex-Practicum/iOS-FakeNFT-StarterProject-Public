//
//  CartViewControllerProtocol.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 06.05.2024.
//

import Foundation

protocol CartViewControllerProtocol: AnyObject {
    func showEmptyCart()
    func updateCartTable()
    func startLoadIndicator()
    func stopLoadIndicator()
}
