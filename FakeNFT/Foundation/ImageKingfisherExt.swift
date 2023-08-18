//
//  ImageKingfisherExt.swift
//  FakeNFT
//
//  Created by macOS on 24.06.2023.
//

import Kingfisher
import UIKit

extension UIImageView {
    func loadImage(url: URL, cornerRadius: CGFloat) {
        self.kf.setImage(
            with: url,
            options: [.cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
}
