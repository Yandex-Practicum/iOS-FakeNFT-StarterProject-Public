//
//  NFTErrorView.swift
//  FakeNFT
//
//  Created by Kirill on 14.07.2023.
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

    private let image: UIImageView = {
        let image = UIImageView()
        image.image = .init(named: "errorImage")
        return image
    }()

    private let title: UILabel = {
        let title = UILabel()
        title.text = "Упс! Что-то пошло не так :(\nПопробуйте ещё раз!"
        title.font = .boldSystemFont(ofSize: 22)
        title.numberOfLines = 2
        title.textAlignment = .center
        return title
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Попробовать еще раз", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.contentEdgeInsets = UIEdgeInsets(top: 19, left: 0, bottom: 19, right: 0)
        return button
    }()

    private let buttonAction: () -> Void

    init(buttonAction: @escaping () -> Void) {
        self.buttonAction = buttonAction
        super.init(frame: .null)
        setupSubviews()
        setupButtonRecognizer()
        backgroundColor = .appWhite
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButtonRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        button.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func buttonTapped() {
        buttonAction()
    }

    private func setupSubviews() {
        image.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        addSubview(image)
        addSubview(title)
        addSubview(button)

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 187),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44),

            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),

            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -200)
        ])
    }
}
