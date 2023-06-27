import UIKit
import Kingfisher

final class EditProfileView: UIView {
    private var viewController: EditProfileViewController?
    
    // MARK: - Properties
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage.Icons.close, for: .normal)
        closeButton.addTarget(self, action: #selector(closeDidTap), for: .touchUpInside)
        return closeButton
    }()
    
    private lazy var avatarImage: UIImageView = {
        let placeholder = UIImage(named: "UserImageDummy")
        let avatarImage = UIImageView(image: placeholder)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.layer.cornerRadius = 35
        avatarImage.layer.masksToBounds = true
        return avatarImage
    }()
    
    private lazy var changeAvatarLabel: UILabel = {
        let changeAvatarLabel = UILabel()
        changeAvatarLabel.translatesAutoresizingMaskIntoConstraints = false
        changeAvatarLabel.backgroundColor = .black.withAlphaComponent(0.6)
        changeAvatarLabel.layer.cornerRadius = 35
        changeAvatarLabel.layer.masksToBounds = true
        changeAvatarLabel.text = "Сменить фото"
        changeAvatarLabel.numberOfLines = 0
        changeAvatarLabel.font = .systemFont(ofSize: 10)
        changeAvatarLabel.textColor = .white
        changeAvatarLabel.textAlignment = .center
        let tapAction = UITapGestureRecognizer(target: self, action:#selector(changeAvatarDidTap(_:)))
        changeAvatarLabel.isUserInteractionEnabled = true
        changeAvatarLabel.addGestureRecognizer(tapAction)
        return changeAvatarLabel
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.attributedText = NSAttributedString(string:"Имя", attributes: [.kern: 0.35])
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.textColor = .black
        return nameLabel
    }()
    
    private lazy var nameTextField: TextField = {
        let nameTextField = TextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
        nameTextField.font = .systemFont(ofSize: 17)
        nameTextField.backgroundColor = .lightGray
        nameTextField.layer.cornerRadius = 12
        nameTextField.layer.masksToBounds = true
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.delegate = self
        return nameTextField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.attributedText = NSAttributedString(string:"Описание", attributes: [.kern: 0.35])
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 22)
        descriptionLabel.textColor = .black
        return descriptionLabel
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let descriptionTextField = UITextView()
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
//        descriptionTextField.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
        descriptionTextField.font = .systemFont(ofSize: 17)
        descriptionTextField.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        descriptionTextField.backgroundColor = .lightGray
        descriptionTextField.layer.cornerRadius = 12
        descriptionTextField.layer.masksToBounds = true
        descriptionTextField.delegate = self
        return descriptionTextField
    }()
    
    private lazy var websiteLabel: UILabel = {
        let websiteLabel = UILabel()
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.attributedText = NSAttributedString(string:"Сайт", attributes: [.kern: 0.35])
        websiteLabel.font = UIFont.boldSystemFont(ofSize: 22)
        websiteLabel.textColor = .black
        return websiteLabel
    }()
    
    private lazy var websiteTextField: TextField = {
        let websiteTextField = TextField()
        websiteTextField.translatesAutoresizingMaskIntoConstraints = false
        websiteTextField.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
        websiteTextField.font = .systemFont(ofSize: 17)
        websiteTextField.backgroundColor = .lightGray
        websiteTextField.layer.cornerRadius = 12
        websiteTextField.layer.masksToBounds = true
        websiteTextField.clearButtonMode = .whileEditing
        websiteTextField.delegate = self
        return websiteTextField
    }()
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewController: EditProfileViewController) {
        super.init(frame: .zero)
        self.viewController = viewController
        
        self.backgroundColor = .white
        addCloseButton()
        addAvatar()
        addNameLabel()
        addDescriptionLabel()
        addWebsiteLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Constraints
    private func addCloseButton() {
        self.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func addAvatar() {
        self.addSubview(avatarImage)
        self.addSubview(changeAvatarLabel)
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: topAnchor, constant: 94),
            avatarImage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            changeAvatarLabel.heightAnchor.constraint(equalToConstant: 70),
            changeAvatarLabel.widthAnchor.constraint(equalToConstant: 70),
            changeAvatarLabel.topAnchor.constraint(equalTo: topAnchor, constant: 94),
            changeAvatarLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
            
        ])
    }
    
    private func addNameLabel() {
        self.addSubview(nameLabel)
        self.addSubview(nameTextField)
        NSLayoutConstraint.activate([
        nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 24),
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
        nameTextField.heightAnchor.constraint(equalToConstant: 46),
        nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func addDescriptionLabel() {
        self.addSubview(descriptionLabel)
        self.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 22),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func addWebsiteLabel() {
        self.addSubview(websiteLabel)
        self.addSubview(websiteTextField)
        NSLayoutConstraint.activate([
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.heightAnchor.constraint(equalToConstant: 46),
            websiteTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    @objc
    func closeDidTap(_ sender: UITapGestureRecognizer) {
        viewController?.dismiss(animated: true)
    }
    
    @objc
    func changeAvatarDidTap(_ sender: UITapGestureRecognizer) {
        print("change!")
    }
}

extension EditProfileView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
