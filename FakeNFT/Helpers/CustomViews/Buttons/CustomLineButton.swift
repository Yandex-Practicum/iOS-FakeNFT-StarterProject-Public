//
//  CustomLineButton.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 14.07.2023.
//

import UIKit

class CustomLineButton: UIButton {
    
    init(number: Int) {
        super.init(frame: .zero)
        setButton(with: number)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButton(with number: Int){
        backgroundColor = .universalWhite
        tag = number
        heightAnchor.constraint(equalToConstant: 4).isActive = true
        layer.cornerRadius = 2
        layoutSubviews()
    }
}
