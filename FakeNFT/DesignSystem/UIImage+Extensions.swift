//
// Created by Андрей Парамонов on 16.12.2023.
//

import UIKit

extension UIImage {
    static var userPhotoPlaceholder: UIImage = {
        let systemName = "person.crop.circle.fill"
        if #available(iOS 15.0, *) {
            let config = UIImage.SymbolConfiguration(paletteColors: [.segmentInactive, .segmentActive])
            return UIImage(systemName: systemName, withConfiguration: config)!
        } else {
            return UIImage(systemName: systemName)!
        }
    }()
}
