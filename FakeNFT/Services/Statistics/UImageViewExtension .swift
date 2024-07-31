//
//  UImageViewExtension .swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 31.07.2024.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
