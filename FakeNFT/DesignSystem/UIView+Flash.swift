//
//  UIView+Flash.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 14.11.2023.
//

import UIKit

extension UIView {
    func addFlashLayer() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 0.5
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = .infinity
        layer.add(flash, forKey: nil)
    }
}
