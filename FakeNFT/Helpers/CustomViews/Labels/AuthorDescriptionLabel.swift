//
//  AuthorDescriptionLabel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 08.07.2023.
//

import UIKit

class AuthorDescriptionLabel: UILabel {
    
    init(size: CGFloat, weight: UIFont.Weight, color: UIColor?) {
        super.init(frame: .zero)
        textColor = color
        font = UIFont.systemFont(ofSize: size, weight: weight)
        textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAttributedText(authorName: String, authorId: String? = nil) {
        let attrString = NSMutableAttributedString()
        let firstLineAttrText = NSMutableAttributedString(string: NSLocalizedString("collectionAuthor", comment: ""))
        let secondLineAttrText = NSMutableAttributedString(string: NSLocalizedString(authorName, comment: ""))
        let range = NSRange(location: 0, length: secondLineAttrText.length)
        
        if let authorId {
            addLink(from: authorId, to: secondLineAttrText, at: range)
        }
        
        secondLineAttrText.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: range)
        attrString.append(firstLineAttrText)
        attrString.append(secondLineAttrText)
        
        attributedText = attrString
        isUserInteractionEnabled = true
    }
}

// MARK: - Ext link
private extension AuthorDescriptionLabel {
    func addLink(from authorId: String, to label: NSMutableAttributedString, at range: NSRange) {
        label.addAttribute(.link, value: K.Links.apiLink + K.EndPoints.author + authorId, range: range)
    }
}
