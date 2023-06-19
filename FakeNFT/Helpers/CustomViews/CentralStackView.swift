//
//  CentralStackView.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 19.06.2023.
//

import UIKit

class CentralStackView: UIStackView {

    init(upperView: UIView, lowerView: UIView, spacing: Double) {
        super.init(frame: .zero)
        axis = .vertical
        alignment = .leading
        distribution = .fillEqually
        self.spacing = spacing
        addArrangedSubview(upperView)
        addArrangedSubview(lowerView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
