//
//  CustomLabel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

class CustomLabel: UILabel {
    
    init(size: CGFloat, weight: UIFont.Weight, color: UIColor?) {
        super.init(frame: .zero)
        textColor = color
        font = UIFont.systemFont(ofSize: size, weight: weight)
        textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
