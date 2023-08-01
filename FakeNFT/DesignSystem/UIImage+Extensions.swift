//
//  UIImage+Extensions.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 01.08.2023.
//

import UIKit

extension UIImage {
    enum Icons {
        static let cart = UIImage.named(AppConstants.Icons.cart)
        static let catalog = UIImage.named(AppConstants.Icons.catalog)
        static let profile = UIImage.named(AppConstants.Icons.profile)
        static let statistics = UIImage.named(AppConstants.Icons.statistics)
        
        static let star = UIImage(systemName: "star.fill")
    }
}

private extension UIImage {
    static func named(_ named: String) -> UIImage {
        guard let image = UIImage(named: named) else {
            assertionFailure("Cannot load image with name: \(named)")
            return UIImage()
        }
        return image
    }
}
