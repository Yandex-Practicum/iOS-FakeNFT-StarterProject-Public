//
//  UIViewController + Ext navBar.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 03.07.2023.
//

import UIKit


extension UIViewController {
    func setupLeftNavBarItem(with title: String?, action: Selector?) {
        guard
            let image = UIImage(systemName: K.Icons.chevronBackward)?
                .withTintColor(
                    .ypBlack ?? .red,
                    renderingMode: .alwaysOriginal
                )
        else { return }
        
        let customLeftItem = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        navigationItem.title = title
        navigationItem.leftBarButtonItem = customLeftItem
    }
    
    func setupRightFilterNavBarItem(with title: String?, action: Selector?) {
        let rightItem = UIBarButtonItem(
            image: UIImage(systemName: K.Icons.filterRightBarButtonIcon),
            style: .plain,
            target: self,
            action: action
        )
        
        rightItem.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.topItem?.title = title
    }
}
