//
//  UIImageView + Ext.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 02.07.2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(from url: URL?) {
        guard let url else  {return }
        self.kf.setImage(with: url)
    }
}
