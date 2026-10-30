import UIKit
import Kingfisher

final class EditProfileViewController: UIViewController {
    
    // MARK: - Свойства
    var onProfileUpdated: ((Profile) -> Void)?
    
    private var profile: Profile
    
    // MARK: - UI Элементы
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .fill 
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 12
        textField.font = .systemFont(ofSize: 17)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 12
        textView.font = .systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var websiteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ссылка на сайт"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 12
        textField.font = .systemFont(ofSize: 17)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init(profile: Profile) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Редактировать профиль"
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        fillFields()
        setupKeyboardDismissGesture()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(dismissScreen)
        )
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(avatarImageView)
        contentStackView.addArrangedSubview(nameTextField)
        contentStackView.addArrangedSubview(descriptionTextView)
        contentStackView.addArrangedSubview(websiteTextField)
        contentStackView.addArrangedSubview(saveButton)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            // Аватарка
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.centerXAnchor.constraint(equalTo: contentStackView.centerXAnchor), // Выравниваем по центру
            
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            websiteTextField.heightAnchor.constraint(equalToConstant: 50),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func fillFields() {
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        websiteTextField.text = profile.website
        
        if let url = URL(string: profile.avatar) {
            avatarImageView.kf.setImage(with: url)
        }
    }
    
    // MARK: - Keyboard Dismiss (Закрытие клавиатуры)
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func dismissScreen() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSave() {
        // Собираем новые данные из полей
        let newName = nameTextField.text?.isEmpty == false ? nameTextField.text! : profile.name
        let newDescription = descriptionTextView.text?.isEmpty == false ? descriptionTextView.text! : profile.description
        let newWebsite = websiteTextField.text?.isEmpty == false ? websiteTextField.text! : profile.website
        
        // Создаем обновленный профиль 
        let updatedProfile = Profile(
            id: profile.id,
            name: newName,
            description: newDescription,
            website: newWebsite,
            avatar: profile.avatar,
            nfts: profile.nfts,
            likes: profile.likes
        )
        
        // Передаем данные на главный экран
        onProfileUpdated?(updatedProfile)
        
        // Закрываем шторку
        dismiss(animated: true)
    }
}
