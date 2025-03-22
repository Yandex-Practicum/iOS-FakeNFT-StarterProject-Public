//
//  UI Table View ext.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 20.03.2025.
//

import UIKit

extension UITableViewCell {
    func setAccessoryView(with color: UIColor) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let symbolImage = UIImage(systemName: "chevron.right", withConfiguration: symbolConfig)
        button.setImage(symbolImage?.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        button.tintColor = color
        self.accessoryView = button
    }
}
