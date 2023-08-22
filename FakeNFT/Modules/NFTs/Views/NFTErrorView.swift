//
//  NFTErrorView.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import UIKit

final class NFTErrorView: UIView {
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        indicator.startAnimating()
        return indicator
    }()

    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "errorImage")
        return view
    }()

    private lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "NFT_ERROR".localized
        view.font = .boldSystemFont(ofSize: 22)
        view.numberOfLines = 1
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.1
        return view
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ONE_MORE_TRY".localized, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.contentEdgeInsets = UIEdgeInsets(top: 19, left: 0, bottom: 19, right: 0)
        button.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(buttonClickedHandler)
            )
        )
        return button
    }()

    private let buttonClickedUserHandler: ExecutionBlock

    init(buttonClickHandler: @escaping ExecutionBlock) {
        buttonClickedUserHandler = buttonClickHandler
        super.init(frame: .null)
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError(
            "NFTErrorView -> init(coder:) has not been implemented"
        )
    }

    @objc private func buttonClickedHandler() {
        buttonClickedUserHandler()
    }

    private func setupSubViews() {
        backgroundColor = .appWhite

        addSubview(image)
        addSubview(title)
        addSubview(button)

        let constraints = [
            image.topAnchor.constraint(equalTo: topAnchor, constant: 187),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44),

            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),

            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -200)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
