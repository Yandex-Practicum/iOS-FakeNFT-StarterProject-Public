//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 05.09.2023.
//

import UIKit
import Kingfisher

final class EditProfileViewController: UIViewController {
    // MARK: - Properties
    let viewmodel: EditProfileViewModel

    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 70/2
        image.clipsToBounds = true
        image.accessibilityIdentifier = AccessibilityIdentifiers.profileImage
        return image
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.text = "Имя"
        label.accessibilityIdentifier = AccessibilityIdentifiers.nameLabel
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
        textField.backgroundColor = .ypLightGrey
        textField.layer.cornerRadius = 12
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.delegate = self
        textField.accessibilityIdentifier = AccessibilityIdentifiers.nameTextField
        return textField
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.text = "Описание"
        label.accessibilityIdentifier = AccessibilityIdentifiers.descriptionLabel
        return label
    }()

    private let descriptionTextField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .label
        textView.backgroundColor = .ypLightGrey
        textView.layer.cornerRadius = 12
        // Разрешаем многострочный текст
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = false

        let paddingViewHeight: CGFloat = 16

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: paddingViewHeight))
        textView.textContainerInset = UIEdgeInsets(
            top: paddingViewHeight,
            left: 16,
            bottom: paddingViewHeight,
            right: 16
        )
        textView.accessibilityIdentifier = AccessibilityIdentifiers.descriptionTextField
        return textView
    }()

    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.text = "Сайт"
        label.accessibilityIdentifier = AccessibilityIdentifiers.urlLabel
        return label
    }()

    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
        textField.backgroundColor = .ypLightGrey
        textField.layer.cornerRadius = 12
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.accessibilityIdentifier = AccessibilityIdentifiers.urlTextField
        return textField
    }()

    private lazy var changeAvatarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сменить фото", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .clear
        button.layer.cornerRadius = 70 / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(changeAvatarButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = AccessibilityIdentifiers.changeAvatarButton
        return button
    }()

    private var changeAvatar: String?

    // MARK: - Initialisers
    init(viewmodel: EditProfileViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layouts()
        setupNavBar()
        setupProfile(with: viewmodel.profile)
    }

    // MARK: - Methods
    private func setupProfile(with profile: Profile) {
        nameTextField.text = profile.name
        descriptionTextField.text = profile.description
        urlTextField.text = profile.website.absoluteString
        profileImage.kf.setImage(with: profile.avatar)
    }

    private func setupNavBar() {
        let button = UIBarButtonItem(
            image: UIImage(named: "close"),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )

        button.tintColor = .label
        button.accessibilityIdentifier = AccessibilityIdentifiers.closeButtonTapped
        navigationItem.setRightBarButton(button, animated: true)
        navigationItem.setHidesBackButton(true, animated: false)
    }

    private func layouts() {
        [profileImage, nameLabel, nameTextField, descriptionLabel, descriptionTextField, urlLabel, urlTextField, changeAvatarButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),

            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            changeAvatarButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            changeAvatarButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            changeAvatarButton.heightAnchor.constraint(equalToConstant: 70),
            changeAvatarButton.widthAnchor.constraint(equalToConstant: 70),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),

            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextField.bottomAnchor.constraint(equalTo: urlLabel.topAnchor, constant: -24),

            urlLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 24),
            urlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            urlTextField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            urlTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func changeAvatarButtonTapped() {
        showAlert()
    }

    @objc private func closeButtonTapped() {
        viewmodel.saveProfile(
            name: nameTextField.text,
            description: descriptionTextField.text,
            websiteString: urlTextField.text,
            newAvatar: changeAvatar
        )
        dismiss(animated: true)
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Ссылка на сайт не валидна",
            preferredStyle: .alert)

        let action = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func showAlert() {
        let alertController = UIAlertController(
            title: "Сменить аватар",
            message: "Введите новый URL",
            preferredStyle: .alert
        )

        alertController.addTextField()
        let addAction = UIAlertAction(
            title: "Ok", style: .default
        ) { [unowned alertController] _ in
            guard let avatarNew = alertController.textFields?[0] else { return }
            self.changeAvatar = avatarNew.text

        }
        addAction.accessibilityIdentifier = AccessibilityIdentifiers.showErrorAlertDoOk
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.text = textField.text ?? ""
        textField.resignFirstResponder()
        return true
    }
}

enum AccessibilityIdentifiers {
    static let profileImage = "profileImage"
    static let nameLabel = "nameLabel"
    static let nameTextField = "nameTextField"
    static let descriptionLabel = "descriptionLabel"
    static let descriptionTextField = "descriptionTextField"
    static let urlLabel = "urlLabel"
    static let urlTextField = "urlTextField"
    static let changeAvatarButton = "changeAvatarButton"
    static let closeButtonTapped = "closeButtonTapped"
    static let showErrorAlertDoOk = "showErrorAlertDoOk"
    static let likeButtonTapped = "likeButtonTapped"
    static let priceSorting = "priceSorting"
    static let ratingSorting = "ratingSorting"
    static let nameSorting = "nameSorting"

    static let devsImageView = "devsImageView"
    static let devsNameLabel = "devsNameLabel"
    static let telegramLabel = "telegramLabel"
    static let emailLabel = "emailLabel"
    static let devsDescriptionLabel = "devsDescriptionLabel"
    static let stackView = "stackView"
}
