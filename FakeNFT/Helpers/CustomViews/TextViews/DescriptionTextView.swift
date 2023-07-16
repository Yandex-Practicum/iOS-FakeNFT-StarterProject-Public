//
//  DescriptionTextView.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 15.07.2023.
//

import UIKit

class DescriptionTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextView() {
        backgroundColor = .clear
        font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        isScrollEnabled = false
        isUserInteractionEnabled = false
    }
}
