//
//  RateStackView.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

class RateStackView: UIStackView {
    
    init(rating: Int) {
        super.init(frame: .zero)
        axis = .horizontal
        alignment = .leading
        distribution = .fillEqually
        spacing = 2
        addRating(rating)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addRating(_ rating: Int) {
        for _ in 0..<rating {
            addArrangedSubview(RateStarButton(appearance: .active))
        }
        
        for _ in 0..<5 - rating {
            addArrangedSubview(RateStarButton(appearance: .notActive))
        }
    }
}
