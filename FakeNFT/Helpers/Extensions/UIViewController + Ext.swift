//
//  UIViewController + Ext.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 20.06.2023.
//

import UIKit

protocol Presentable: AnyObject {
    func getVC() -> UIViewController?
}

extension UIViewController: Presentable {
    func getVC() -> UIViewController? {
        return self
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround(completion: (() -> Void)? = nil) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
