//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 05.09.2023.
//

import UIKit

final class EditProfileViewController: UIViewController {
    // MARK: - Properties
    let mockNft = MockNft.shared

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

    private let nameTextField: UITextField = {
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

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textView.frame.height))

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

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layouts()
        setupNavBar()
        setupProfile()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

       // let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: descriptionTextField.frame.height))
        descriptionTextField.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 0, right: 16)
    }

    // MARK: - Methods
    private func setupProfile() {
        profileImage.image = mockNft.profile.avatar
        nameTextField.text = mockNft.profile.name
        descriptionTextField.text = mockNft.profile.desctoption
        urlTextField.text = mockNft.profile.website

    }
    private func setupNavBar() {
        let button = UIBarButtonItem(image: UIImage(named: "close"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(closeButtonTapped))
        button.tintColor = .label
//        let nextButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
//                                         style: .plain,
//                                         target: self,
//                                         action: #selector(saveProfile))
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
        // save and dissmis
       dismiss(animated: true)
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
//                guard let self = self else { return }
                if let text = alertController.textFields?[0].text,
                   let url = URL(string: text),
                   let valid = self?.verifiUrl(urlString: text),
                   valid { print(url) }
            }
        ))
        self.present(alertController, animated: true, completion: nil)
    }

    func verifiUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }

}
