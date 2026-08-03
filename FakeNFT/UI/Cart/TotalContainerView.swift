//
//  TotalContainerView.swift
//  FakeNFT
//
//  Created by Сергей Петров on 17.07.2026.
//

import UIKit

final class TotalContainerView: UIView {
    var cornerRadius: CGFloat = CartSizeConstants.totalSectionRadius
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
