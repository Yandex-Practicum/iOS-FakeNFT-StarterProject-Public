//
//  AlertViewController.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 14.09.2024.
//

import Foundation
import UIKit

final class AlertVC: UIAlertController {
    private var customColor: UIColor?
    
    func setCustomColor(_ color: UIColor) {
        customColor = color
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let color = customColor, let customView = self.view.superview?.subviews.first {
            customView.backgroundColor = color
        }
    }
}
