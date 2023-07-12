import UIKit
import Kingfisher

final class EditProfileView: UIView {
    
    enum Constraints {
        static let basicLeading = 16.0
        static let basicTrailing = -16.0
        static let basicInterim = 8.0
        static let avatarDimensions = 70.0
    }
    
    // MARK: - Properties
    private var viewModel: ProfileViewModel
    private var viewController: EditProfileViewController
    
    //MARK: - Layout elements
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage.Icons.close, for: .normal)
        closeButton.addTarget(self, action: #selector(closeDidTap), for: .touchUpInside)
        return closeButton
    }()
    
    private lazy var avatarImage: UIImageView = {
        let placeholder = UIImage(named: "UserImagePlaceholder")
        let avatarImage = UIImageView(image: placeholder)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.layer.cornerRadius = 35
        avatarImage.layer.masksToBounds = true
        return avatarImage
    }()
    
    private lazy var changeAvatarLabel: UILabel = {
        let changeAvatarLabel = UILabel()
        changeAvatarLabel.translatesAutoresizingMaskIntoConstraints = false
        changeAvatarLabel.accessibilityIdentifier = "changeAvatarLabel"
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
    
    private lazy var avatarUpdatedURLLabel: UILabel = {
        let avatarUpdatedURLLabel = UILabel()
        avatarUpdatedURLLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarUpdatedURLLabel.layer.cornerRadius = 16
        avatarUpdatedURLLabel.layer.masksToBounds = true
        avatarUpdatedURLLabel.backgroundColor = .white
        avatarUpdatedURLLabel.text = "Загрузить изображение"
        avatarUpdatedURLLabel.font = .systemFont(ofSize: 17)
        avatarUpdatedURLLabel.textAlignment = .center
        avatarUpdatedURLLabel.isHidden = true
        return avatarUpdatedURLLabel
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
    init(frame: CGRect, viewController: EditProfileViewController, viewModel: ProfileViewModel) {
        self.viewController = viewController
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        addCloseButton()
        addAvatar()
        addNameLabel()
        addDescriptionLabel()
        addWebsiteLabel()
        
        getDataFromViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func getDataFromViewModel() {
        avatarImage.kf.setImage(
            with: viewModel.avatarURL,
            placeholder: UIImage(named: "UserImagePlaceholder"),
            options: [.processor(RoundCornerImageProcessor(cornerRadius: 35))])
        avatarUpdatedURLLabel.text = viewModel.avatarURL?.absoluteString
        nameTextField.text = viewModel.name
        descriptionTextView.text = viewModel.description
        websiteTextField.text = viewModel.website
    }
    
    @objc
    private func closeDidTap(_ sender: UITapGestureRecognizer) {
        guard let name = nameTextField.text, !name.isEmpty,
              let avatar = avatarUpdatedURLLabel.text,
              let description = descriptionTextView.text, !description.isEmpty,
              let website = websiteTextField.text, !website.isEmpty,
              let likes = viewModel.likes else { return }
        
        viewModel.putProfileData(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            likes: likes
        )
        viewController.dismiss(animated: true)
    }
    
    @objc
    private func changeAvatarDidTap(_ sender: UITapGestureRecognizer) {
        avatarUpdatedURLLabel.isHidden = false
        let alert = UIAlertController(
            title: "Загрузить изображение",
            message: "Укажите ссылку на аватар",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "Введите ссылку:"
        })
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: UIAlertAction.Style.default,
            handler: {_ in
                guard let textField = alert.textFields?[0],
                      let updatedURL = textField.text else { return }
                
                if self.verifyUrl(urlString: updatedURL) {
                    self.avatarUpdatedURLLabel.text = updatedURL
                } else {
                    let wrongURLalert = UIAlertController(
                        title: "Неверная ссылка",
                        message: "Проверьте формат ссылки",
                        preferredStyle: .alert)
                    wrongURLalert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self.viewController.present(wrongURLalert, animated: true)
                }
            }))
        self.viewController.present(alert, animated: true, completion: nil)
    }
    
    private func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != descriptionTextView &&
                touch.view != nameTextField &&
                touch.view != websiteTextField {
                descriptionTextView.resignFirstResponder()
                nameTextField.resignFirstResponder()
                websiteTextField.resignFirstResponder()
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: - Layout methods
    private func addCloseButton() {
        self.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constraints.basicTrailing)
        ])
    }
    
    private func addAvatar() {
        self.addSubview(avatarImage)
        self.addSubview(changeAvatarLabel)
        self.addSubview(avatarUpdatedURLLabel)
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: Constraints.avatarDimensions),
            avatarImage.widthAnchor.constraint(equalToConstant: Constraints.avatarDimensions),
            avatarImage.topAnchor.constraint(equalTo: topAnchor, constant: 94),
            avatarImage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            changeAvatarLabel.heightAnchor.constraint(equalTo: avatarImage.heightAnchor),
            changeAvatarLabel.widthAnchor.constraint(equalTo: avatarImage.widthAnchor),
            changeAvatarLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor),
            changeAvatarLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            avatarUpdatedURLLabel.topAnchor.constraint(equalTo: changeAvatarLabel.bottomAnchor, constant: 4),
            avatarUpdatedURLLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarUpdatedURLLabel.heightAnchor.constraint(equalToConstant: 44),
            avatarUpdatedURLLabel.widthAnchor.constraint(equalToConstant: 250)
            
        ])
    }
    
    private func addNameLabel() {
        self.addSubview(nameLabel)
        self.addSubview(nameTextField)
        NSLayoutConstraint.activate([
        nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 24),
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.basicLeading),
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constraints.basicInterim),
        nameTextField.heightAnchor.constraint(equalToConstant: 46),
        nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.basicLeading),
        nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constraints.basicTrailing)
        ])
    }
    
    private func addDescriptionLabel() {
        self.addSubview(descriptionLabel)
        self.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 22),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.basicLeading),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constraints.basicInterim),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.basicLeading),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constraints.basicTrailing)
        ])
    }
    
    private func addWebsiteLabel() {
        self.addSubview(websiteLabel)
        self.addSubview(websiteTextField)
        NSLayoutConstraint.activate([
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.basicLeading),
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: Constraints.basicInterim),
            websiteTextField.heightAnchor.constraint(equalToConstant: 46),
            websiteTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.basicLeading),
            websiteTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constraints.basicTrailing)
        ])
    }
}

// MARK: - Extensions
extension EditProfileView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileView: UITextViewDelegate {
    
}
