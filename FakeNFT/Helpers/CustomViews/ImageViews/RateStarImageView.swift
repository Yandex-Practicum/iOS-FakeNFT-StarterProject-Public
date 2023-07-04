//
//  RateStarImageView.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

class RateStarImageView: UIImageView {

    init(appearance: Appearance) {
        super.init(frame: .zero)
        setAppearance(for: appearance)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RateStarImageView {
    func setAppearance(for appearance: Appearance) {
        switch appearance {
        case .active:
            image = UIImage(named: K.Icons.activeStarRate)
        case .notActive:
            image = UIImage(named: K.Icons.notActiveStarRate)
        }
    }
}

extension RateStarImageView {
    enum Appearance {
        case active, notActive
    }
}
