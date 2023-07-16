//
//  NftIMageView.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 04.07.2023.
//

import UIKit

class NftIMageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = 12
        contentMode = .scaleAspectFit
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
