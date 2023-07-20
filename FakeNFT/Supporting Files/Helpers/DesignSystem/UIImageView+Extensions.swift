//
//  UIImageView+Extensions.swift
//  FakeNFT
//
//  Created by Илья Валито on 19.06.2023.
//

import UIKit
import Kingfisher

extension UIImageView {

    func loadImage(urlString: String?) {
        guard let url = URL(string: urlString ?? "") else { return }
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url,
                         placeholder: UIImage(named: Constants.ImageNames.placeholder)
        ) { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                print(error)
            }
        }
    }
}
