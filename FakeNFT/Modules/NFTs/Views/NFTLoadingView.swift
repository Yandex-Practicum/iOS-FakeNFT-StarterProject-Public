//
//  NFTLoadingview.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import UIKit

final class NFTLoadingView: UIView {
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        view.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        view.startAnimating()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError(
            "NFTLoadingView -> init(coder:) has not been implemented"
        )
    }

    private func setupSubViews() {
        backgroundColor = .appWhite

        addSubview(indicator)

        let constraints = [
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
