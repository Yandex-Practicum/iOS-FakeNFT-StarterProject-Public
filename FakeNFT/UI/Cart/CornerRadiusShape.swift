//
//  CornerRadiusShape.swift
//  FakeNFT
//
//  Created by Сергей Петров on 17.07.2026.
//

import UIKit

final class CornerRadiusView: UIView {
    var radius: CGFloat = .infinity { didSet { setNeedsLayout() } }
    var corners: UIRectCorner = .allCorners { didSet { setNeedsLayout() } }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyMask()
    }

    private func applyMask() {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
