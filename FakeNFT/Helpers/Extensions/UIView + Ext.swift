//
//  UIView + Ext.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 13.07.2023.
//

import UIKit

extension UIView {
    func addGradient(frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1).cgColor,
            UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0).cgColor,
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: -0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.masksToBounds = true
        gradientLayer.frame = frame
        
        layer.addSublayer(gradientLayer)
        layoutSubviews()
    }
}
