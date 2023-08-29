//
//  UIStackViewExtension.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 13.08.2023.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
