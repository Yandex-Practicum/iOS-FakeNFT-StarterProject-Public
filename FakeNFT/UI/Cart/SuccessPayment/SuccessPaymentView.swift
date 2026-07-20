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
        let imageView = UIImageView(image: UIImage(named: "successPaymentImage"))
        imageView.contentMode = .scaleAspectFit // Аналог .scaledToFit()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Успех! Оплата прошла, поздравляем с покупкой!", comment: "Текст успешной оплаты")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold) // Аналог .bold22
        label.textColor = UIColor(named: "yaBlack") ?? .black
        label.textAlignment = .center // Аналог .multilineTextAlignment(.center)
        label.numberOfLines = 0 // Разрешаем перенос строк
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Вернуться в корзину", comment: "Кнопка возврата в корзину"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold) // Аналог .bold17
        button.setTitleColor(UIColor(named: "yaWhite") ?? .white, for: .normal)
        button.backgroundColor = UIColor(named: "yaBlack") ?? .black
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
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // Скрываем навигационную панель при появлении (аналог .navigationBarHidden(true))
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // Возвращаем навигационную панель при исчезновении (чтобы она была на других экранах)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground // Или .white, в зависимости от дизайна
        
        view.addSubview(successImageView)
        view.addSubview(titleLabel)
        view.addSubview(returnButton)
        
        returnButton.addTarget(self, action: #selector(returnTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 1. Изображение (центрировано, но слегка смещено вверх, чтобы оставить место для кнопки)
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            successImageView.widthAnchor.constraint(equalToConstant: CartSizeConstants.successImageSize),
            successImageView.heightAnchor.constraint(equalToConstant: CartSizeConstants.successImageSize),
            
            // 2. Заголовок (под изображением с отступом 20, как .padding(.bottom, 20) у картинки)
            titleLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36), // .padding(.horizontal, 36)
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            // 3. Кнопка (прижата к низу безопасной зоны с отступом 16)
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), // .padding(16)
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            returnButton.heightAnchor.constraint(equalToConstant: CartSizeConstants.successButtonHeight),
            
            // 4. Аналог Spacer() между заголовком и кнопкой:
            // Гарантируем, что на маленьких экранах кнопка не наедет на текст
            returnButton.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: - Actions
    @objc private func returnTapped() {
        // Вызываем переданный замыкание
        onReturn()
        
        // Если экран был показан модально, закрываем его
        dismiss(animated: true)
        
        // ИЛИ, если он был запушен в навигационный стек, раскомментируй строку ниже:
        // navigationController?.popViewController(animated: true)
    }
}
