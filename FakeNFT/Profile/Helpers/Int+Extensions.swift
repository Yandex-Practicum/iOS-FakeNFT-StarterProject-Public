//
//  Int+Extensions.swift
//  FakeNFT
//
//  Created by Юрий Демиденко on 30.05.2023.
//

import UIKit

extension Int {

    var ratingString: NSAttributedString {
        let fullString = NSMutableAttributedString(string: "")
        for rating in 1...5 {
            let imageAttachment = NSTextAttachment()
            imageAttachment.bounds = CGRect(origin: .zero, size: CGSize(width: 14, height: 13))
            if rating <= self && self != 0 {
                imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.ratingStarYellow)
                fullString.append(NSAttributedString(attachment: imageAttachment))
            } else {
                imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.ratingStarLightGray)
                fullString.append(NSAttributedString(attachment: imageAttachment))
            }
        }
        return fullString
    }
}
