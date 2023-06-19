//
//  UICreator.swift
//  FakeNFT
//
//  Created by Илья Валито on 19.06.2023.
//

import Foundation

import UIKit

struct UICreator {

    static let shared = UICreator()

    func makeLabel(text: String? = nil,
                   font: UIFont = UIFont.appFont(.bold, withSize: 22),
                   color: UIColor = .appBlack,
                   alignment: NSTextAlignment = .left,
                   andNumberOfLines numberOfLines: Int = 0
    ) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.text = text
        return label
    }

    func makeImageView(withImage: String? = nil, cornerRadius: CGFloat?) -> UIImageView {
        let imageView = UIImageView()
        if let cornerRadius {
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = cornerRadius
        }
        guard let imageName = withImage else { return imageView }
        imageView.image = UIImage(named: imageName)
        return imageView
    }

    func makeLinkTextView(withFont font: UIFont = UIFont.appFont(.regular, withSize: 15)) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textAlignment = .justified
        textView.font = font
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.contentInset = UIEdgeInsets(top: -8, left: -5, bottom: 0, right: 0)
        return textView
    }

    func makeActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .appBlack
        return activityIndicator
    }

    func makeTableView(isScrollable: Bool = true) -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = isScrollable
        return tableView
    }
}
