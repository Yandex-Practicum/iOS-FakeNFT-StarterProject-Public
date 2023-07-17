//
//  ProfileImageView.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 16.07.2023.
//

import UIKit

class ProfileImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentMode = .scaleAspectFill
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        layer.cornerRadius = 35
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
