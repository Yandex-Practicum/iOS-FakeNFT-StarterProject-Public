//
//  UIViewController+Extensions.swift
//  FakeNFT
//
//  Created by Юрий Демиденко on 26.05.2023.
//

import UIKit

extension UIViewController {
    func hideKeyboardByTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
