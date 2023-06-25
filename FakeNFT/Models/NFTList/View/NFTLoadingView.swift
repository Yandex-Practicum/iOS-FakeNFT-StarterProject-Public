//
//  NFTLoadingView.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

class NFTLoadingView: UIView {
    private let _indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        indicator.startAnimating()
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupSubviews()
        backgroundColor = .appWhite
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupSubviews() {
        _indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(_indicator)
        NSLayoutConstraint.activate([
            _indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            _indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
