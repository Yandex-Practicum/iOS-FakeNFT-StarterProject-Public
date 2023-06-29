//
//  UICreator.swift
//  FakeNFT
//
//  Created by Илья Валито on 19.06.2023.
//

import Foundation

import UIKit

struct UICreator {

    static func makeLabel(text: String? = nil,
                          font: UIFont = UIFont.appFont(.bold, withSize: 22),
                          color: UIColor = .appBlack,
                          backgroundColor: UIColor = .clear,
                          alignment: NSTextAlignment = .left,
                          andNumberOfLines numberOfLines: Int = 0
    ) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.backgroundColor = backgroundColor
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.text = text
        return label
    }

    static func makeTextField(withTarget action: Selector? = nil,
                              font: UIFont = UIFont.appFont(.regular, withSize: 17),
                              tag: Int = 0
    ) -> CustomTextField {
        let textField = CustomTextField()
        textField.backgroundColor = .appLightGray
        textField.textColor = .appBlack
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 12
        textField.tag = tag
        if let button = textField.value(forKey: "clearButton") as? UIButton {
            button.tintColor = .appGray
            button.setImage(UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            textField.clearButtonMode = .whileEditing
        }
        if let action {
            textField.addTarget(nil, action: action, for: .editingChanged)
        }
        return textField
    }

    static func makeImageView(withImage: String? = nil, cornerRadius: CGFloat?) -> UIImageView {
        let imageView = UIImageView()
        if let cornerRadius {
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = cornerRadius
        }
        guard let imageName = withImage else { return imageView }
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    static func makeTextView(withFont font: UIFont = UIFont.appFont(.regular, withSize: 15),
                             haveLinks: Bool = false,
                             backgroundColor: UIColor = .appLightGray
    ) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = backgroundColor
        textView.textAlignment = .left
        textView.font = font
        textView.isEditable = !haveLinks
        textView.isScrollEnabled = !haveLinks
        textView.contentInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        if haveLinks {
            textView.dataDetectorTypes = .link
            textView.contentInset = UIEdgeInsets(top: -8, left: -5, bottom: 0, right: 0)
        }
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 12
        return textView
    }

    static func makeButton(withTitle title: String? = nil,
                           font: UIFont = UIFont.appFont(.medium, withSize: 17),
                           fontColor: UIColor = .appBlack,
                           backgroundColor: UIColor = .clear,
                           cornerRadius: CGFloat = 12,
                           action: Selector
    ) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = font
        button.setTitleColor(fontColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        button.addTarget(nil, action: action, for: .touchUpInside)
        button.tintColor = .appBlack
        return button
    }

    static func makeActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .appBlack
        return activityIndicator
    }

    static func makeTableView(isScrollable: Bool = true) -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = isScrollable
        return tableView
    }

    static func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        collectionView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return collectionView
    }

    static func makeStackView(withAxis axis: NSLayoutConstraint.Axis = .vertical,
                              distribution: UIStackView.Distribution = .fill,
                              align: UIStackView.Alignment = .fill,
                              cornerRadius: CGFloat = 0.0,
                              andSpacing spacing: CGFloat = 8
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.layer.cornerRadius = cornerRadius
        return stackView
    }
}
