import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Private Dependencies:
    private var viewModel: AuthViewModelProtocol
    
    // MARK: - UI:
    private lazy var authScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        return scrollView
    }()
    
    private lazy var enterTittleLabel: UILabel = {
        let label = UILabel()
        label.font = .headlineLarge
        label.textColor = .blackDay
        label.text = L10n.Authorization.enter
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.textColor = .blackDay
        textField.backgroundColor = .lightGrayDay
        textField.placeholder = "Email"
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.textColor = .blackDay
        textField.backgroundColor = .lightGrayDay
        textField.placeholder = L10n.Authorization.password
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var enterButton = BaseBlackButton(with: L10n.Authorization.entering)
    
    private lazy var forgetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle(L10n.Authorization.forgetPassword, for: .normal)
        button.setTitleColor(.blackDay, for: .normal)
        button.titleLabel?.font = .captionSmallerRegular
        
        return button
    }()
    
    private lazy var demoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle(L10n.Authorization.demo, for: .normal)
        button.setTitleColor(.blueUniversal, for: .normal)
        button.titleLabel?.font = .captionMediumBold
        
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle(L10n.Authorization.registration, for: .normal)
        button.setTitleColor(.blackDay, for: .normal)
        button.titleLabel?.font = .captionMediumBold
        
        return button
    }()
    
    private lazy var loginPasswordMistakeLabel: UILabel = {
        let label = UILabel()
        label.font = .bodySmallerRegular
        label.textColor = .redUniversal
        label.textAlignment = .left
        label.text = L10n.Authorization.Error.loginPasswordMistake
        
        return label
    }()
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupObservers()
        setupTargets()
        
        initializeHideKeyboard()
        bind()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    init(viewModel: AuthViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods:
    private func bind() {
        viewModel.loginPasswordMistakeObservable.bind { [weak self] newValue in
            guard let self = self else { return }
            self.unblockUI()
            if newValue == true {
                self.showLoginPasswordMistake()
            } else {
                self.hideLoginPasswordMistake()
            }
        }
        
        viewModel.isAuthorizationDidSuccesfulObserver.bind { [weak self] newValue in
            guard let self = self else { return }
            self.unblockUI()
            if newValue == false {
                print(L10n.Alert.Authorization.title)
                print(L10n.Alert.Authorization.message)
            } else {
                self.switchToTabBarController()
            }
        }
    }
    
    private func switchToTabBarController() {
        let viewController = TabBarController()
        viewController.modalPresentationStyle = .overFullScreen
        
        present(viewController, animated: true)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func initializeHideKeyboard() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    private func showLoginPasswordMistake() {
        enterButton.isEnabled = false
        enterButton.backgroundColor = .gray
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.view.setupView(loginPasswordMistakeLabel)
            self.emailTextField.layer.borderWidth = 1
            self.emailTextField.layer.borderColor = UIColor.redUniversal.cgColor
            self.passwordTextField.layer.borderWidth = 1
            self.passwordTextField.layer.borderColor = UIColor.redUniversal.cgColor
            
            NSLayoutConstraint.activate([
                self.loginPasswordMistakeLabel.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 16),
                self.loginPasswordMistakeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                self.loginPasswordMistakeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16)
            ])
        }
    }
    
    private func hideLoginPasswordMistake() {
        enterButton.isEnabled = true
        enterButton.backgroundColor = .blackDay
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.loginPasswordMistakeLabel.removeFromSuperview()
            self.emailTextField.layer.borderWidth = 0
            self.passwordTextField.layer.borderWidth = 0
        }
    }
    
    // MARK: - Objc Methods:
    @objc private func authorizeUser() {
        blockUI()
        viewModel.authorize()
    }
    
    @objc private func switchToRegistrateVC() {
        let viewModel = RegistrationViewModel()
        let viewController = RegistrationViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .overFullScreen
        
        present(viewController, animated: true)
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.authScrollView.contentSize.height = authScrollView.frame.height + keyboardFrameSize.height
            self.authScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrameSize.height, right: 0)
        }
    }
    
    @objc private func keyboardDidHide() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.authScrollView.contentSize.height = authScrollView.frame.height
        }
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideLoginPasswordMistake()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.setNewLoginPassword(login: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
}

// MARK: - Setup Views:
extension AuthViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        
        view.setupView(authScrollView)
        [enterTittleLabel, emailTextField, passwordTextField, enterButton,
         forgetPasswordButton, demoButton, registrationButton].forEach(authScrollView.setupView)
    }
}

// MARK: - Setup Constraints:
extension AuthViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            authScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            authScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            enterTittleLabel.topAnchor.constraint(equalTo: authScrollView.topAnchor, constant: 176),
            enterTittleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enterTittleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 46),
            emailTextField.topAnchor.constraint(equalTo: enterTittleLabel.bottomAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 46),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            enterButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 84),
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            forgetPasswordButton.topAnchor.constraint(equalTo: enterButton.bottomAnchor, constant: 16),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            demoButton.heightAnchor.constraint(equalToConstant: 60),
            demoButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 67),
            demoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            demoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            registrationButton.heightAnchor.constraint(equalToConstant: 60),
            registrationButton.topAnchor.constraint(equalTo: demoButton.bottomAnchor, constant: 12),
            registrationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            registrationButton.bottomAnchor.constraint(lessThanOrEqualTo: authScrollView.bottomAnchor, constant: -60),
            registrationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Setup Views:
extension AuthViewController {
    private func setupTargets() {
        registrationButton.addTarget(self, action: #selector(switchToRegistrateVC), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(authorizeUser), for: .touchUpInside)
    }
}
