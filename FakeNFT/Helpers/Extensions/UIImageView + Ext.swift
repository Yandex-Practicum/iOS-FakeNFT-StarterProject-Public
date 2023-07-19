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
        guard let url else { return }
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, options: [.cacheSerializer(FormatIndicatedCacheSerializer.png)]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                self.kf.indicatorType = .none
            case .failure(_):
                self.kf.indicatorType = .none
                image = UIImage(named: K.Icons.placeholder)
            }
        }
    }
}
