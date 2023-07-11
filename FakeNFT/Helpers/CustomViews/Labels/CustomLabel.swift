//
//  CustomLabel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

class CustomLabel: UILabel {
    
    init(size: CGFloat, weight: UIFont.Weight, color: UIColor?, alignment: NSTextAlignment? = nil) {
        super.init(frame: .zero)
        textColor = color
        font = UIFont.systemFont(ofSize: size, weight: weight)
        textAlignment = alignment ?? .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateLabelAppearance() {
        alpha = 0.0
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.alpha = 1.0
        }
    }
}
