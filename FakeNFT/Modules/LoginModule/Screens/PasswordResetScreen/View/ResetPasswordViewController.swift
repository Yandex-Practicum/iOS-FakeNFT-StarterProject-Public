//
//  ResetPasswordViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 12.07.2023.
//

import UIKit
import Combine

protocol ResetPasswordCoordinatable {
    var onCancel: (() -> Void)? { get set }
}

final class ResetPasswordViewController: UIViewController, ResetPasswordCoordinatable {
    var onCancel: (() -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    let viewModel: ResetPasswordViewModel
    
    private lazy var titleLabel: CustomLabel = {
        let label = CustomLabel(size: 34, weight: .bold, color: .ypBlack, alignment: .natural)
        label.text = K.Titles.loginLabelChangePasswordTitle
        return label
    }()
    
    private lazy var emailTextField: LoginTextField = {
        let textField = LoginTextField(labelPlaceholder: K.Titles.emailTextFieldTitle)
        return textField
    }()
    
    private lazy var resetButton: CustomActionButton = {
        let button = CustomActionButton(title: K.Titles.loginButtonTitle, appearance: .confirm)
        button.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var messageLabel: CustomLabel = {
        let label = CustomLabel(size: 13, weight: .regular, color: .universalGreen, alignment: .natural)
        label.alpha = 0
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = view.frame.height * K.Spacing.loginBaseSpacingCoefficient
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emailTextField)
        return stackView
    }()
    
    // MARK: Init
    init(viewModel: ResetPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .universalWhite
        setupLeftNavBarItem(with: nil, action: #selector(cancelTapped))
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
    }
    
    // MARK: Bind
    private func bind() {
        viewModel.$passwordResetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.updateUI(from: result)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Ext show result message
private extension ResetPasswordViewController {
    func updateUI(from result: RequestResult?) {
        guard let result else { return }
        setMessageText(with: result)
        setMessageColor(with: result)
        changeMessageLabelState(for: result)
        manageEnterButtonAppearence(result)
        
    }
    
    func setMessageText(with result: RequestResult) {
        messageLabel.text = result.passwordResetResultMessage
    }
    
    func setMessageColor(with result: RequestResult) {
        messageLabel.textColor = result.passwordResetTextColor
    }
    
    func changeMessageLabelState(for result: RequestResult) {
        result == .loading ? hideMessageLabel() : animateMessageLabelAppearence()
    }
    
    func manageEnterButtonAppearence(_ result: RequestResult) {
        switch result {
        case .success:
            resetButton.setAppearance(for: .hidden)
        case .failure:
            resetButton.setAppearance(for: .confirm)
        case .loading:
            resetButton.setAppearance(for: .disabled)
        }
    }
    
    func animateMessageLabelAppearence() {
        messageLabel.animateLabelAppearance()
    }
    
    func hideMessageLabel() {
        messageLabel.alpha = 0
    }
}

// MARK: - Ext @objc
@objc private extension ResetPasswordViewController {
    func resetTapped() {
        viewModel.resetPassword(for: emailTextField.text)
    }
    
    func cancelTapped() {
        onCancel?()
    }
}

// MARK: - Ext Constraints
private extension ResetPasswordViewController {
    func setupConstraints() {
        setupMainStackView()
        setupMessageLabel()
        setupResetButton()
    }
    
    func setupMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 88),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupMessageLabel() {
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            messageLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupResetButton() {
        view.addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 36),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resetButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
