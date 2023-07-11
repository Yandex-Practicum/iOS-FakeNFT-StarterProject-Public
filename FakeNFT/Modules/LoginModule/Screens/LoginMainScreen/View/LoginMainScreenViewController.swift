//
//  LoginMainScreenViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 10.07.2023.
//

import UIKit

protocol LoginMainCoordinatableProtocol {
    var onEnter: (() -> Void)? { get set }
    var onRegister: (() -> Void)? { get set }
    var onForgottenPassword: (() -> Void)? { get set }
    var onDemo: (() -> Void)? { get set }
}

final class LoginMainScreenViewController: UIViewController & LoginMainCoordinatableProtocol {

    var onEnter: (() -> Void)?
    var onRegister: (() -> Void)?
    var onForgottenPassword: (() -> Void)?
    var onDemo: (() -> Void)?
    
    private let viewModel: LoginMainScreenViewModel
    
    private lazy var loginLabel: CustomLabel = {
        let label = CustomLabel(size: 34, weight: .bold, color: .ypBlack, alignment: .left)
        label.text = K.Titles.loginLabelEnterTitle
        return label
    }()
    
    private lazy var emailTextField: LoginTextField = {
        let textField = LoginTextField(title: K.Titles.emailTextFieldTitle)
        return textField
    }()
    
    private lazy var passwordTextField: LoginTextField = {
        let textField = LoginTextField(title: K.Titles.passwordTextFieldTitle)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var enterButton: CustomActionButton = {
        let button = CustomActionButton(title: K.Titles.enterButtonTitle, appearance: .confirm)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(enterTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorLabel: CustomLabel = {
        let label = CustomLabel(size: 13, weight: .regular, color: .universalRed, alignment: .left)
        return label
    }()
    
    private lazy var loadingView: CustomAnimatedView = {
        let view = CustomAnimatedView(frame: .zero)
        return view
    }()
    
    private lazy var actionView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return view
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(K.Titles.forgotPasswordButtonTitle, for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var demoButton: CustomActionButton = {
        let button = CustomActionButton(title: K.Titles.demoButtonTitle, appearance: .demo)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(demoTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: CustomActionButton = {
        let button = CustomActionButton(title: K.Titles.registerButtonTitle, appearance: .transparent)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(actionView)
        return stackView
    }()
    
    private lazy var enterAndForgotStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(enterButton)
        stackView.addArrangedSubview(forgotPasswordButton)
        return stackView
    }()
    
    private lazy var demoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.addArrangedSubview(demoButton)
        stackView.addArrangedSubview(registerButton)
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = view.frame.height * 0.075
        stackView.addArrangedSubview(loginLabel)
        stackView.addArrangedSubview(textFieldStackView)
        stackView.addArrangedSubview(enterAndForgotStackView)
        stackView.addArrangedSubview(demoStackView)
        return stackView
    }()
    
    
    
    // MARK: Init
    init(viewModel: LoginMainScreenViewModel) {
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
        setupConstraints()
        hideKeyboardWhenTappedAround()
    } 
}

// MARK: - Ext @objc
@objc private extension LoginMainScreenViewController {
    func enterTapped() {
        viewModel.enterTapped()
    }
    
    func registerTapped() {
        onRegister?()
    }
    
    func forgotPasswordTapped() {
        onForgottenPassword?()
    }
    
    func demoTapped() {
        onDemo?()
    }
}

// MARK: - Ext Constraints
private extension LoginMainScreenViewController {
    func setupConstraints() {
        setupEnterStackView()
    }
    
    func setupEnterStackView() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -26)
        ])
    }
}
