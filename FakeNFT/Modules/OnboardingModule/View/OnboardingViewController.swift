//
//  OnboardingViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 12.07.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    let viewModel: OnboardingViewModel
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleLabel: CustomLabel = {
        let label = CustomLabel(size: 32, weight: .bold, color: .universalWhite, alignment: .left)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: K.Icons.xmark)?.withTintColor(.universalWhite, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageDescription: CustomLabel = {
        let label = CustomLabel(size: 15, weight: .regular, color: .universalWhite, alignment: .left)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(pageDescription)
        return stackView
    }()
    
    private lazy var proceedButton: CustomActionButton = {
        let button = CustomActionButton(title: K.Titles.onboardingProceedButtonTitle, appearance: .confirm)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Init
    init(viewModel: OnboardingViewModel, page: OnboardingPage) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupPages(from: page)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyBackgroundGradient()
    }
    
    private func setupPages(from page: OnboardingPage) {
        backgroundImageView.image = page.backgroundImage
        titleLabel.text = page.titleLabelText
        pageDescription.text = page.pageDescription
        closeButton.isHidden = page.closeButtonIsHidden
        proceedButton.isHidden = page.proceedButtonIsHidden
    }
}

// MARK: - Ext @objc
@objc private extension OnboardingViewController {
    func closeTapped() {
        viewModel.exitOnboarding()
        print("close")
    }
}

// MARK: - Ext Gradient layer
private extension OnboardingViewController {
    func applyBackgroundGradient() {
        backgroundImageView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        backgroundImageView.addGradient(frame: backgroundImageView.frame)
    }
}

// MARK: - Ext Constraints
private extension OnboardingViewController {
    func setupConstraints() {
        setupBackgroundImageView()
        setupCloseButton()
        setupText()
        setupProceedButton()
    }
    
    func setupBackgroundImageView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    func setupText() {
        view.addSubview(textStackView)
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func setupProceedButton() {
        view.addSubview(proceedButton)
        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            proceedButton.heightAnchor.constraint(equalToConstant: 60),
            proceedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            proceedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            proceedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -66)
        ])
    }
}
