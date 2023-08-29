import UIKit

final class ProfileEditViewController: UIViewController {
    // MARK: - Public properties
    
    var presenter: ProfileEditPresenterProtocol?
    var delegate: ProfileViewDelegate?
    
    // MARK: - Private properties
    
    private let nameLabel = EditedParameterLabel.init(text: NSLocalizedString("profile.name", comment: ""))
    private let descriptionLabel = EditedParameterLabel.init(text: NSLocalizedString("profile.description", comment: ""))
    private let siteLabel = EditedParameterLabel.init(text: NSLocalizedString("profile.site", comment: ""))
    
    // swiftlint:disable:next trailing_closure
    private lazy var nameTextField = CustomTextField(
        with: NSLocalizedString("profile.name.placeholder", comment: ""),
        textChangeHandler: { [weak self] newText in
            self?.presenter?.change(parameter: .name, with: newText)
        }
    )
    // swiftlint:disable:next trailing_closure
    private lazy var descriptionTextView = CustomTextView(
        with: NSLocalizedString("profile.description.placeholder", comment: ""),
        text: profile.description,
        textChangeHandler: { [weak self] newText in
            self?.presenter?.change(parameter: .description, with: newText)
        }
    )
    // swiftlint:disable:next trailing_closure
    private lazy var siteTextField = CustomTextField(
        with: NSLocalizedString("profile.site.placeholder", comment: ""),
        textChangeHandler: { [weak self] newText in
            self?.presenter?.change(parameter: .site, with: newText)
        }
    )
    
    private let photoView: UIImageView = {
        let view = UIImageView()
        view.layer.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: ProfileConstants.profilePhotoSideSize,
                height: ProfileConstants.profilePhotoSideSize
            )
        )
        view.backgroundColor = .ypBlack
        view.layer.cornerRadius = ProfileConstants.profilePhotoSideSize/2
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var newPhotoUrlLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("profile.photo.download", comment: "")
        label.backgroundColor = .clear
        label.font = .bodyRegular
        label.layer.cornerRadius = 16
        label.textAlignment = .center
        label.isHidden = true
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.contentMode = .scaleAspectFit
        stack.axis = .vertical
        stack.layer.masksToBounds = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var closeButton: UIButton = {
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .semibold)
        let button = UIButton.systemButton(
            with: UIImage(systemName: "xmark", withConfiguration: symbolConfiguration) ?? UIImage(),
            target: self,
            action: #selector(didTapCloseButton)
        )
        button.frame.size = CGSize(width: 42, height: 42)
        button.tintColor = .ypBlack
        return button
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlackUniversal.withAlphaComponent(0.6)
        button.layer.cornerRadius = ProfileConstants.profilePhotoSideSize/2
        button.setTitle(NSLocalizedString("profile.photo.change", comment: ""), for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.setTitleColor(.ypWhiteUniversal, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(changePhotoDidTap), for: .touchUpInside)
        button.layer.zPosition = 2
        return button
    }()
    
    private var profile: EditableProfileModel
    
    // MARK: - Life cycle
    
    init(editableProfile: EditableProfileModel) {
        profile = editableProfile
        photoView.image = profile.avatarImage
        
        super.init(nibName: nil, bundle: nil)
        
        nameTextField.text = profile.name
        siteTextField.text = profile.website.absoluteString
        descriptionTextView.text = profile.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addingUIElements()
        layoutConfigure()
        nameTextField.delegate = self
        siteTextField.delegate = self
        descriptionTextView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
        guard let isProfileChanged = presenter?.profileChanged else { return }
        if isProfileChanged {
            guard let profile = presenter?.newProfile else { return }
            delegate?.sendNewProfile(profile)
        } else {
            dismiss(animated: true)
        }
    }
}
    
    // MARK: - Private methods
extension ProfileEditViewController {
    private func addingUIElements() {
        view.addSubview(mainStack)
        
        [closeButton, photoView, nameLabel, descriptionLabel, siteLabel, nameTextField, descriptionTextView, siteTextField, changePhotoButton, newPhotoUrlLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainStack.addSubview($0)
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: mainStack.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            
            photoView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            photoView.widthAnchor.constraint(equalToConstant: ProfileConstants.profilePhotoSideSize),
            photoView.heightAnchor.constraint(equalToConstant: ProfileConstants.profilePhotoSideSize),
            photoView.centerXAnchor.constraint(equalTo: mainStack.centerXAnchor),
            
            changePhotoButton.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            changePhotoButton.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
            changePhotoButton.heightAnchor.constraint(equalTo: photoView.heightAnchor),
            changePhotoButton.widthAnchor.constraint(equalTo: photoView.widthAnchor),
            
            newPhotoUrlLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 4),
            newPhotoUrlLabel.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            newPhotoUrlLabel.widthAnchor.constraint(equalToConstant: 250),
            newPhotoUrlLabel.heightAnchor.constraint(equalToConstant: 44),
            
            nameLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            nameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            nameTextField.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 132),
            
            siteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            siteLabel.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            
            siteTextField.topAnchor.constraint(equalTo: siteLabel.bottomAnchor, constant: 8),
            siteTextField.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            siteTextField.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            siteTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            siteTextField.heightAnchor.constraint(lessThanOrEqualToConstant: 60)
        ])
    }
    
    private func showURLInputAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("profile.photo.title", comment: ""),
            message: NSLocalizedString("profile.photo.message", comment: ""),
            preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("profile.photo.placeholder", comment: "")
        }
        let okAction = UIAlertAction(
            title: NSLocalizedString("profile.photo.okButton", comment: ""),
            style: .default
        ) { [weak self] _ in
            guard
                let self = self, let textField = alert.textFields?.first,
                let updatedURL = textField.text
            else { return }
            
            if self.isValidURL(urlString: updatedURL) {
                self.newPhotoUrlLabel.text = updatedURL
                self.presenter?.change(parameter: .imageUrl, with: updatedURL)
            } else {
                self.showInvalidURLAlert()
            }
        }
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("profile.photo.cancelButton", comment: ""),
            style: .cancel
        )
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func isValidURL(urlString: String) -> Bool {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            return false
        }
        return true
    }
    
    private func showInvalidURLAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("profile.photo.invalidURLTitle", comment: ""),
            message: NSLocalizedString("profile.photo.invalidURLMessage", comment: ""),
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: NSLocalizedString("profile.photo.okButton", comment: ""),
            style: .cancel
        )
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Actioins
    
    @objc private func changePhotoDidTap() {
        newPhotoUrlLabel.isHidden = false
        showURLInputAlert()
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let textFieldMaxY = siteTextField.frame.maxY
        let keyboardHeight = keyboardFrame.height
        
        let offsetY = presenter?.calculateViewYOffset(
            textFieldY: textFieldMaxY,
            viewHeight: view.frame.height,
            keyboardHeight: keyboardHeight
        ) ?? 0
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -offsetY
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
}


// MARK: - Extension UITextFieldDelegate

extension ProfileEditViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
