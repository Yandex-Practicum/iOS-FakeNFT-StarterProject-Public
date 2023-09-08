//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 05.09.2023.
//

import UIKit
import Kingfisher

final class EditProfileViewController: UIViewController {
    let mockNft = MockNft.shared
    // MARK: - Properties
    let viewmodel: EditProfileViewModel

    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 70/2
        image.clipsToBounds = true
        return image
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.text = "Имя"
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
        textField.backgroundColor = .ypLightGray
        textField.layer.cornerRadius = 12
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.delegate = self

        return textField
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.text = "Описание"
        return label
    }()

    private let descriptionTextField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .label
        textView.backgroundColor = .ypLightGray
        textView.layer.cornerRadius = 12
          // Разрешаем многострочный текст
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = false

        let paddingViewHeight: CGFloat = 16

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: paddingViewHeight))
        textView.textContainerInset = UIEdgeInsets(top: paddingViewHeight, left: 16, bottom: paddingViewHeight, right: 16)

        return textView
    }()

    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.text = "Сайт"
        return label
    }()

    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
        textField.backgroundColor = .ypLightGray
        textField.layer.cornerRadius = 12
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
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
        return button
    }()

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
        let buttonSave = UIBarButtonItem(
            image: UIImage(systemName: "checkmark"),
            style: .plain,
            target: self,
            action: #selector(saveProfile)
        )
        navigationItem.setRightBarButtonItems([button, buttonSave], animated: true)
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
      showErrorAlert()
       dismiss(animated: true)
    }

    @objc private func saveProfile() {
        guard verifiUrl(urlString: urlTextField.text) ?? false else {
            showErrorAlert()
            return
        }
        viewmodel.saveProfile(
            name: nameTextField.text,
            description: descriptionTextField.text,
            websiteString: urlTextField.text
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
        alertController.addTextField { (textField) in
            textField.text = " "
        }

        alertController.addAction(UIAlertAction(
            title: "Ок",
            style: .default,
            handler: { [weak self] (_) in
              guard let self = self else { return }
                if let text = alertController.textFields?[0].text,
                   let url = URL(string: text),
                   let valid = self.verifiUrl(urlString: text),
                   valid { print(url) }
            }
        ))
        self.present(alertController, animated: true, completion: nil)
    }

    func verifiUrl (urlString: String?) -> Bool? {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }

}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.text = textField.text ?? ""
        textField.resignFirstResponder()
        return true
    }
}
