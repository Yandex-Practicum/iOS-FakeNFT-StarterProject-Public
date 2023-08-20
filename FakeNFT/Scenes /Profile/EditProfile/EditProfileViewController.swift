import UIKit

final class EditProfileViewController: UIViewController {
    private let viewModel: EditProfileViewModelProtocol
    private weak var delegate: ProfileUpdateDelegate?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "closeButton"
        button.setImage(UIImage.Icons.close, for: .normal)
        button.addTarget(self, action: #selector(closeDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView(image: UIImage.Icons.userPlaceholder)
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var changeAvatarLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "changeAvatarLabel"
        label.backgroundColor = .appBlack.withAlphaComponent(0.6)
        label.layer.cornerRadius = 35
        label.layer.masksToBounds = true
        label.text = "Сменить фото"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 10)
        label.textColor = .appWhite
        label.textAlignment = .center
        let tapAction = UITapGestureRecognizer(
            target: self,
            action: #selector(changeAvatarDidTap(_:))
        )
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapAction)
        return label
    }()
    
    private lazy var avatarUpdateURLLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.backgroundColor = .appWhite
        label.text = "Загрузить изображение"
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Имя", attributes: [.kern: 0.35])
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var nameTextField: TextField = {
        let textField = TextField()
        textField.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .appLightGray
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Описание", attributes: [.kern: 0.35])
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.backgroundColor = .appLightGray
        textView.layer.cornerRadius = 12
        textView.layer.masksToBounds = true
        textView.delegate = self
        return textView
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Сайт", attributes: [.kern: 0.35])
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var websiteTextField: TextField = {
        let textField = TextField()
        textField.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .appLightGray
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    
    init(viewModel: EditProfileViewModelProtocol, delegate: ProfileUpdateDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        getData()
        view.backgroundColor = .appWhite
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.update()
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

    @objc
    private func closeDidTap(_ sender: UITapGestureRecognizer) {
        guard
            let name = nameTextField.text,
            !name.isEmpty,
            let stringUrl = avatarUpdateURLLabel.text,
            !stringUrl.isEmpty,
            let description = descriptionTextView.text,
            !description.isEmpty,
            let website = websiteTextField.text,
            !website.isEmpty
        else { return }
        
        viewModel.updateProfile(profile: ProfileModel(
            name: name,
            avatar: stringUrl,
            description: description,
            website: website,
            nfts: viewModel.profile?.nfts ?? [],
            likes: viewModel.profile?.likes ?? [],
            id: viewModel.profile?.id ?? ""
        ))
        self.dismiss(animated: true)
    }
    
    @objc
    private func changeAvatarDidTap(_ sender: UITapGestureRecognizer) {
        avatarUpdateURLLabel.isHidden = false
        let alert = UIAlertController(
            title: "Загрузить изображение",
            message: "Укажите ссылку на аватар",
            preferredStyle: .alert
        )
        
//        alert.addTextField(configurationHandler: {(textField: UITextField) in
//            textField.placeholder = "Введите ссылку:"
//        })
        
        alert.addAction(UIAlertAction(
            title: "Ок",
            style: .default,
            handler: { [weak self] _ in
                guard
                    let self = self,
                    let textField = alert.textFields?[0],
                    let updateURL = textField.text
                else { return }
                
                if checkURL(urlString: updateURL) {
                    self.avatarUpdateURLLabel.text = updateURL
                } else {
                    let wrongURLAlert = UIAlertController(
                        title: "Неверная ссылка",
                        message: "Проверьте формат ссылки",
                        preferredStyle: .alert)
                    wrongURLAlert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: { _ in
                        wrongURLAlert.dismiss(animated: true)
                    }))
                    self.present(wrongURLAlert, animated: true)
                }
                alert.dismiss(animated: true)
            })
        )
        self.present(alert, animated: true)
    }
    
    private func getData() {
        avatarImage.loadImage(
            urlString: viewModel.profile?.avatar,
            placeholder: UIImage.Icons.userPlaceholder,
            radius: 35)
        avatarUpdateURLLabel.text = viewModel.profile?.avatar
        nameTextField.text = viewModel.profile?.name
        descriptionTextView.text = viewModel.profile?.description
        websiteTextField.text = viewModel.profile?.website
    }
    
    // MARK: - Layout
    private func setupConstraints() {
        [closeButton,
         avatarImage,
         changeAvatarLabel,
         avatarUpdateURLLabel,
         nameLabel,
         nameTextField,
         descriptionLabel,
         descriptionTextView,
         websiteLabel,
         websiteTextField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 94),
            avatarImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            changeAvatarLabel.heightAnchor.constraint(equalTo: avatarImage.heightAnchor),
            changeAvatarLabel.widthAnchor.constraint(equalTo: avatarImage.widthAnchor),
            changeAvatarLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor),
            changeAvatarLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            avatarUpdateURLLabel.topAnchor.constraint(equalTo: changeAvatarLabel.bottomAnchor, constant: 4),
            avatarUpdateURLLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarUpdateURLLabel.heightAnchor.constraint(equalToConstant: 44),
            avatarUpdateURLLabel.widthAnchor.constraint(equalToConstant: 250),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.heightAnchor.constraint(equalToConstant: 46),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 22),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.heightAnchor.constraint(equalToConstant: 46),
            websiteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension EditProfileViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
