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
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url,
                         placeholder: UIImage(named: Constants.ImageNames.placeholder),
                         options: [.processor(processor)]
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
