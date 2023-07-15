//
//  LoginMainScreenViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 10.07.2023.
//

import UIKit
import Combine

protocol LoginMainCoordinatableProtocol {
    var onEnter: (() -> Void)? { get set }
    var onForgottenPassword: (() -> Void)? { get set }
    var onDemo: (() -> Void)? { get set }
}

final class LoginMainScreenViewController: UIViewController & LoginMainCoordinatableProtocol {

    var onEnter: (() -> Void)?
    var onForgottenPassword: (() -> Void)?
    var onDemo: (() -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: LoginMainScreenViewModel
    
    private lazy var loginLabel: CustomLabel = {
        let label = CustomLabel(size: 34, weight: .bold, color: .ypBlack, alignment: .natural)
        label.text = K.Titles.loginLabelEnterTitle
        return label
    }()
    
    private lazy var emailTextField: LoginTextField = {
        let textField = LoginTextField(labelPlaceholder: K.Titles.emailTextFieldTitle)
        return textField
    }()
    
    private lazy var passwordTextField: LoginTextField = {
        let textField = LoginTextField(labelPlaceholder: K.Titles.passwordTextFieldTitle)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var enterButton: CustomActionButton = {
        let button = CustomActionButton(title: K.Titles.loginButtonTitle, appearance: .confirm)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    private lazy var errorLabel: CustomLabel = {
        let label = CustomLabel(size: 13, weight: .regular, color: .universalRed, alignment: .natural)
        label.alpha = 0
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var loadingView: CustomAnimatedView = {
        let view = CustomAnimatedView(frame: .zero)
        return view
    }()
    
    private lazy var actionView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        view.addSubview(errorLabel)
        view.addSubview(loadingView)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.frame = view.bounds
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
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
        stackView.spacing = view.frame.height * K.Spacing.loginBaseSpacingCoefficient
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
        viewModel.clearRequest()
        hideCredentialsErrorState()
    }
    
    // MARK: bind
    private func bind() {
        viewModel.$requestResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loginResult in
                self?.updateLoginResult(loginResult)
            }
            .store(in: &cancellables)
        
        viewModel.$actionType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] actionType in
                self?.updateCurrentView(for: actionType)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .sink { [weak self] message in
                self?.updateErrorLabel(message)
            }
            .store(in: &cancellables)
    }
    
    private func createCredentials() -> LoginCredentials {
        LoginCredentials(email: emailTextField.text, password: passwordTextField.text)
    }
}

// MARK: - Ext ErrorMessage
private extension LoginMainScreenViewController {
    func updateErrorLabel(_ message: String?) {
        guard let message else { return }
        errorLabel.text = message
    }
}

// MARK: - Ext Result animation
private extension LoginMainScreenViewController {
    func updateLoginResult(_ result: RequestResult?) {
        guard let result else { return }
        disableEnterButtonWhileLoading(result)
        stopLoadingAnimation()
        showLoadingAnimation(for: result)
        changeCredentialsErrorState(for: result)
        proceedToCatalog(result)
    }
    
    func disableEnterButtonWhileLoading(_ result: RequestResult) {
        switch result {
        case .success:
            break
        case .failure:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.enterButton.setAppearance(for: .confirm)
            }
        case .loading:
            enterButton.setAppearance(for: .disabled)
        }
    }
    
    func stopLoadingAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadingView.stopAnimation()
        }
    }
    
    func showLoadingAnimation(for result: RequestResult) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.loadingView.result = result
            self.loadingView.startAnimation()
        }
    }
    
    func changeCredentialsErrorState(for result: RequestResult) {
        result == .failure ? showCredentialsErrorState() : hideCredentialsErrorState()
    }
    
    func proceedToCatalog(_ result: RequestResult?) {
        guard let result else { return }
        if result == .success { onEnter?() }
    }
}

// MARK: - error state
private extension LoginMainScreenViewController {
    func showCredentialsErrorState() {
        setErrorState(with: 1)
        errorLabel.animateLabelAppearance()
        
    }
    
    func hideCredentialsErrorState() {
        setErrorState(with: 0)
        errorLabel.alpha = 0
    }
    
    func setErrorState(with borderWidth: CGFloat) {
        emailTextField.layer.borderWidth = borderWidth
        passwordTextField.layer.borderWidth = borderWidth
    }
}

// MARK: - login/register view change
private extension LoginMainScreenViewController {
    func updateCurrentView(for action: ActionType) {
        addButtonTarget(from: action)
        changeActionButtonTitle(for: action)
        hideOrShowLowerButtons(for: action)
    }
    
    func addButtonTarget(from action: ActionType) {
        switch action {
        case .login:
            enterButton.removeTarget(self, action: #selector(registerTapped), for: .touchUpInside)
            enterButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        case .register:
            enterButton.removeTarget(self, action: #selector(loginTapped), for: .touchUpInside)
            enterButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        }
    }
    
    func changeActionButtonTitle(for action: ActionType) {
        enterButton.setTitle(action.buttonTitle, for: .normal)
    }
    
    func hideOrShowLowerButtons(for action: ActionType) {
        lowerButtonsHiddenState(action.hiddenState)
    }
    
    func lowerButtonsHiddenState(_ isHidden: Bool) {
        forgotPasswordButton.isHidden = isHidden
        demoButton.isHidden = isHidden
        registerButton.isHidden = isHidden
    }
}

// MARK: - Ext @objc
@objc private extension LoginMainScreenViewController {
    func loginTapped() {
        viewModel.login(with: createCredentials())
    }
    
    func registerTapped() {
        viewModel.register(with: createCredentials())
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
