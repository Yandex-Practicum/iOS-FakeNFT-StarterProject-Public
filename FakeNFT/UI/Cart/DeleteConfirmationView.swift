//
//  DeleteConfirmationView.swift
//  FakeNFT
//
//  Created by Сергей Петров on 17.07.2026.
//
import UIKit

final class DeleteConfirmationView: UIView {

    var onConfirm: (() -> Void)?
    var onCancel: (() -> Void)?

    init(item: CartItem) {
        super.init(frame: .zero)
        setupUI(item: item)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI(item: nil)
    }

    private func setupUI(item: CartItem?) {
        // Делаем сам контейнер полностью прозрачным
        backgroundColor = .clear
        
        // Image
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = CartSizeConstants.modalImageRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: CartSizeConstants.modalImageSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: CartSizeConstants.modalImageSize).isActive = true
        imageView.image = UIImage(named: item?.name ?? "")

        // Message label
        let messageLabel = UILabel()
        messageLabel.text = "Вы уверены, что хотите\nудалить объект из корзины?"
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .black // Белый текст, так как фон теперь темный размытый
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        // Delete button
        let deleteButton = UIButton(type: .custom)
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        deleteButton.layer.cornerRadius = CartSizeConstants.modalButtonRadius
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.widthAnchor.constraint(equalToConstant: 127).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        deleteButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)

        // Return button
        let returnButton = UIButton(type: .custom)
        returnButton.setTitle("Вернуться", for: .normal)
        returnButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        returnButton.setTitleColor(.white, for: .normal)
        returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        returnButton.layer.cornerRadius = CartSizeConstants.modalButtonRadius
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        returnButton.widthAnchor.constraint(equalToConstant: 127).isActive = true
        returnButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        returnButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        // Buttons horizontal stack
        let buttonsStack = UIStackView(arrangedSubviews: [deleteButton, returnButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 8
        buttonsStack.distribution = .fill
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false

        // Main vertical stack
        let mainStack = UIStackView(arrangedSubviews: [imageView, messageLabel, buttonsStack])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            buttonsStack.centerXAnchor.constraint(equalTo: mainStack.centerXAnchor),
        ])
    }

    @objc private func confirmTapped() { onConfirm?() }
    @objc private func cancelTapped() { onCancel?() }
}
