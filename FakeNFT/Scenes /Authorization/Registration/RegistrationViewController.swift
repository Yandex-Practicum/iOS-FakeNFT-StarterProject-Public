import UIKit

final class RegistrationViewController: UIViewController {
    
    // MARK: - Private Dependencies:
    private var viewModel: RegistrationViewModelProtocol
    
    // MARK: - UI
    private lazy var authScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        return scrollView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .blackDay
        
        return button
    }()
    
    private lazy var enterTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .headlineLarge
        label.textColor = .blackDay
        label.text = L10n.Authorization.registrate
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
    
    private lazy var registrationButton = BaseBlackButton(with: L10n.Authorization.registration)
    
    private lazy var loginPasswordMistakeLabel: UILabel = {
        let label = UILabel()
        label.font = .bodySmallerRegular
        label.textColor = .redUniversal
        label.textAlignment = .left
        
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupTargets()
        setupObservers()
        
        initializeHideKeyboard()
        bind()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(viewModel: RegistrationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods:
    private func bind() {
        viewModel.isInputPasswordCorrectObservable.bind { [weak self] newValue in
            guard let self = self else { return }
            self.unblockUI()
            if newValue == false {
                self.showLoginPasswordMistake()
                self.loginPasswordMistakeLabel.text = viewModel.errorDiscription
            }
        }
        
        viewModel.isInputMailCorrectObservable.bind { [weak self] newValue in
            guard let self = self else { return }
            self.unblockUI()
            if newValue == false {
                self.showLoginPasswordMistake()
                self.loginPasswordMistakeLabel.text = viewModel.errorDiscription
            }
        }
        
        viewModel.isRegistrationDidSuccesfulObserver.bind { [weak self] newValue in
            guard let self = self else { return }
            self.unblockUI()
            if newValue == true {
                self.switchToOnboardingViewController()
            } else {
                self.showLoginPasswordMistake()
                self.loginPasswordMistakeLabel.text = viewModel.errorDiscription
            }
        }
        
        viewModel.isUserMistakeObservable.bind { [weak self] _ in
            guard let self = self else { return }
            self.unblockUI()
            self.showLoginPasswordMistake()
        }
    }
    
    private func switchToOnboardingViewController() {
        let viewModel = OnboardingViewModel()
        let viewController = OnboardingViewController(viewModel: viewModel, delegate: self)
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
    
    private func showLoginPasswordMistake() {
        registrationButton.isEnabled = false
        registrationButton.backgroundColor = .gray
        
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
        registrationButton.isEnabled = true
        registrationButton.backgroundColor = .blackDay
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.loginPasswordMistakeLabel.removeFromSuperview()
            self.emailTextField.layer.borderWidth = 0
            self.passwordTextField.layer.borderWidth = 0
        }
    }
    
    private func initializeHideKeyboard() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: - Objc Methods:
    @objc private func registrateUser() {
        blockUI()
        viewModel.registrateNewAccount()
    }
    
    @objc private func backToAuthVC() {
        dismiss(animated: true)
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

// MARK: - OnboardingViewControllerDelegate
extension RegistrationViewController: OnboardingViewControllerDelegate {
    func backToAuth() {
        dismiss(animated: false)
    }
}

// MARK: - UITextViewDelegate
extension RegistrationViewController: UITextFieldDelegate {
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
extension RegistrationViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        
        view.setupView(authScrollView)
        [enterTitleLabel, emailTextField, passwordTextField, registrationButton,
         backButton].forEach(authScrollView.setupView)
    }
}

// MARK: - Setup Constraints:
extension RegistrationViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            authScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            authScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(equalTo: authScrollView.topAnchor, constant: 55),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            
            enterTitleLabel.topAnchor.constraint(equalTo: authScrollView.topAnchor, constant: 176),
            enterTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enterTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 46),
            emailTextField.topAnchor.constraint(equalTo: enterTitleLabel.bottomAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 46),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            registrationButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 84),
            registrationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            registrationButton.bottomAnchor.constraint(equalTo: authScrollView.bottomAnchor, constant: -293),
            registrationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Setup Targets:
extension RegistrationViewController {
    private func setupTargets() {
        backButton.addTarget(self, action: #selector(backToAuthVC), for: .touchUpInside)
        registrationButton.addTarget(self, action: #selector(registrateUser), for: .touchUpInside)
    }
}
