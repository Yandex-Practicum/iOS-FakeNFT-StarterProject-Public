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
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var avatarWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private lazy var cameraIconView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        imageView.image = UIImage(systemName: "camera.fill", withConfiguration: config)
        imageView.tintColor = UIColor(named: "YPBlack") ?? .black
        imageView.backgroundColor = UIColor(named: "YPBackground") ?? .systemGray6
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 11.28
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameTitleLabel: UILabel = createTitleLabel(text: "Имя")
    private lazy var descriptionTitleLabel: UILabel = createTitleLabel(text: "Описание")
    private lazy var websiteTitleLabel: UILabel = createTitleLabel(text: "Сайт")
    
    // Добавляем addTarget, чтобы отслеживать ввод текста
    private lazy var nameTextField: UITextField = {
        let textField = createTextField(placeholder: "Введите имя")
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var websiteTextField: UITextField = {
        let textField = createTextField(placeholder: "Введите ссылку")
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }()
    
    // Добавляем делегат для UITextView
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: "YPBackground") ?? .systemGray6
        textView.layer.cornerRadius = 12
        textView.font = UIFont(name: "SFProText-Regular", size: 17) ?? .systemFont(ofSize: 17)
        textView.textColor = UIColor(named: "YPBlack") ?? .black
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.delegate = self // Делегат для отслеживания изменений
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // ВЫТАСКИВАЕМ КНОПКУ ИЗ СТЕКА. Скрываем её по умолчанию.
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 17) ?? .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(named: "YPBlack") ?? .black
        button.layer.cornerRadius = 16
        button.isHidden = true // Скрыта при открытии
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
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
        title = "Редактирование профиля"
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        fillFields()
        setupKeyboardDismissGesture()
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(dismissScreen)
        )
        backButton.tintColor = UIColor(named: "YPBlack") ?? .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // Добавляем кнопку прямо на view, а не в стек
        view.addSubview(saveButton)
        
        avatarContainerView.addSubview(avatarImageView)
        avatarContainerView.addSubview(cameraIconView)
        avatarWrapperView.addSubview(avatarContainerView)
        
        // Собираем стек (без кнопки!)
        contentStackView.addArrangedSubview(avatarWrapperView)
        contentStackView.setCustomSpacing(24, after: avatarWrapperView)
        
        contentStackView.addArrangedSubview(nameTitleLabel)
        contentStackView.setCustomSpacing(8, after: nameTitleLabel)
        contentStackView.addArrangedSubview(nameTextField)
        contentStackView.setCustomSpacing(24, after: nameTextField)
        
        contentStackView.addArrangedSubview(descriptionTitleLabel)
        contentStackView.setCustomSpacing(8, after: descriptionTitleLabel)
        contentStackView.addArrangedSubview(descriptionTextView)
        contentStackView.setCustomSpacing(24, after: descriptionTextView)
        
        contentStackView.addArrangedSubview(websiteTitleLabel)
        contentStackView.setCustomSpacing(8, after: websiteTitleLabel)
        contentStackView.addArrangedSubview(websiteTextField)
        
        // Добавляем отступ внизу стека, чтобы кнопка не перекрывала поля ввода
        contentStackView.setCustomSpacing(100, after: websiteTextField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            avatarWrapperView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            avatarContainerView.centerXAnchor.constraint(equalTo: avatarWrapperView.centerXAnchor),
            avatarContainerView.topAnchor.constraint(equalTo: avatarWrapperView.topAnchor),
            avatarContainerView.bottomAnchor.constraint(equalTo: avatarWrapperView.bottomAnchor),
            avatarContainerView.widthAnchor.constraint(equalToConstant: 72.56),
            avatarContainerView.heightAnchor.constraint(equalToConstant: 70),
            
            avatarImageView.topAnchor.constraint(equalTo: avatarContainerView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: avatarContainerView.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            cameraIconView.trailingAnchor.constraint(equalTo: avatarContainerView.trailingAnchor),
            cameraIconView.bottomAnchor.constraint(equalTo: avatarContainerView.bottomAnchor),
            cameraIconView.widthAnchor.constraint(equalToConstant: 22.56),
            cameraIconView.heightAnchor.constraint(equalToConstant: 22.56),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            
            // ПОЗИЦИОНИРОВАНИЕ КНОПКИ ИЗ МАКЕТА (343x60, отступ 16)
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Привязываем к клавиатуре: если она открыта - кнопка над ней, если закрыта - над Safe Area
            saveButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16)
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
    
    // MARK: - Отслеживание изменений
    @objc private func textDidChange() {
        checkForChanges()
    }
    
    private func checkForChanges() {
        let isNameChanged = nameTextField.text != profile.name
        let isWebsiteChanged = websiteTextField.text != profile.website
        let isDescriptionChanged = descriptionTextView.text != profile.description
        
        let hasChanges = isNameChanged || isWebsiteChanged || isDescriptionChanged
        
        // Плавно показываем или скрываем кнопку
        UIView.animate(withDuration: 0.2) {
            self.saveButton.isHidden = !hasChanges
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func didTapSave() {
        let newName = nameTextField.text?.isEmpty == false ? nameTextField.text! : profile.name
        let newDescription = descriptionTextView.text?.isEmpty == false ? descriptionTextView.text! : profile.description
        let newWebsite = websiteTextField.text?.isEmpty == false ? websiteTextField.text! : profile.website
        
        let updatedProfile = Profile(
            id: profile.id,
            name: newName,
            description: newDescription,
            website: newWebsite,
            avatar: profile.avatar,
            nfts: profile.nfts,
            likes: profile.likes
        )
        
        onProfileUpdated?(updatedProfile)
        dismiss(animated: true)
    }
    
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
    @objc private func dismissScreen() { dismiss(animated: true) }
    
    // MARK: - Helpers
    private func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "SFProText-Bold", size: 22) ?? .systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(named: "YPBlack") ?? .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.backgroundColor = UIColor(named: "YPBackground") ?? .systemGray6
        textField.layer.cornerRadius = 12
        textField.font = UIFont(name: "SFProText-Regular", size: 17) ?? .systemFont(ofSize: 17)
        textField.textColor = UIColor(named: "YPBlack") ?? .black
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}

// ОБЯЗАТЕЛЬНО: расширение для UITextView, чтобы отслеживать изменения в описании
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkForChanges()
    }
}
