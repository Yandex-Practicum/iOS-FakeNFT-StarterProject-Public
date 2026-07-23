//
//  SuccessPaymentView.swift
//  FakeNFT
//
//  Created by Сергей Петров on 20.07.2026.
//

import UIKit

// MARK: - SuccessPaymentViewController
final class SuccessPaymentViewController: UIViewController {
    
    // MARK: - Properties
    private let onReturn: () -> Void
    
    // MARK: - UI Elements
    private let successImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .successPayment))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Успех! Оплата прошла, поздравляем с покупкой!", comment: "Текст успешной оплаты")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(resource: .yaBlack)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Вернуться в корзину", comment: "Кнопка возврата в корзину"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(UIColor(resource: .yaWhite), for: .normal)
        button.backgroundColor = UIColor(resource: .yaBlack)
        button.layer.cornerRadius = CartSizeConstants.successButtonRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init(onReturn: @escaping () -> Void) {
        self.onReturn = onReturn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(successImageView)
        view.addSubview(titleLabel)
        view.addSubview(returnButton)
        
        returnButton.addTarget(self, action: #selector(returnTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            successImageView.widthAnchor.constraint(equalToConstant: CartSizeConstants.successImageSize),
            successImageView.heightAnchor.constraint(equalToConstant: CartSizeConstants.successImageSize),
            
            titleLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            returnButton.heightAnchor.constraint(equalToConstant: CartSizeConstants.successButtonHeight),

            returnButton.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: - Actions
    @objc private func returnTapped() {
        onReturn()
        
        dismiss(animated: true)
    }
}
