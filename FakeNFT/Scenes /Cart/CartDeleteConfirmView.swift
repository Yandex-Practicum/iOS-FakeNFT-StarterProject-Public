//
//  CartDeleteConfirmView.swift
//  FakeNFT
//
//  Created by Александр Акимов on 23.04.2024.
//

import UIKit

final class CartDeleteConfirmView: UIViewController {

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Cart.deleteBttn", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.redUniversal, for: .normal)
        button.backgroundColor = UIColor(named: "blackDayNight")
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Cart.cancelBttn", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = UIColor(named: "blackDayNight")
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()

    private let imageViews: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "mockCart")
        return image
    }()

    private let confirmLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "Вы уверены, что хотите\nудалить объект из корзины?"
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()

    private let imageStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    @objc private func deleteTapped() {
        dismiss(animated: true)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        configureView()
        configureConstraits()
    }

    private func configureView() {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        view.addSubview(blurView)
        [imageStack,
         buttonsStack].forEach {
            view.addSubview($0)
        }
        [deleteButton,
        cancelButton].forEach {
            buttonsStack.addArrangedSubview($0)
        }
        [imageViews,
         confirmLabel].forEach {
            imageStack.addArrangedSubview($0)
        }
    }

    private func configureConstraits() {
        NSLayoutConstraint.activate([
            imageViews.heightAnchor.constraint(equalToConstant: 108),
            imageViews.widthAnchor.constraint(equalToConstant: 108),

            imageStack.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: -20),
            imageStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),

            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalToConstant: 127),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}
