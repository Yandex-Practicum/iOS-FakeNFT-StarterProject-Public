//
//  RateStackView.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

class RateStackView: UIStackView {
    
    init() {
        super.init(frame: .zero)
        axis = .horizontal
        alignment = .leading
        distribution = .fillEqually
        spacing = 2
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateRating(_ rating: Int) {
        removeRating()
        
        for _ in 0..<rating {
            addActiveStars()
        }
        
        for _ in 0..<5 - rating {
            addNotActiveStars()
        }
        
    }
    
    func removeRating() {
        arrangedSubviews.forEach { subview in
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
    private func addActiveStars() {
        addArrangedSubview(RateStarImageView(appearance: .active))
    }
    
    private func addNotActiveStars() {
        addArrangedSubview(RateStarImageView(appearance: .notActive))
    }
}
