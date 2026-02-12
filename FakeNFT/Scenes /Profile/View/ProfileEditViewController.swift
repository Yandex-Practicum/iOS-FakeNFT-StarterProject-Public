//
//  ProfileEditViewController.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 22.01.2026.
//

import UIKit

// MARK: - Protocols

protocol ProfileEditViewProtocol: AnyObject {
    func showProfile(model: ProfileEditModel)
    func closeSave()
    func showExitAlert()
    func showAvatarAlert()
    func showPhotoLinkAlert()
}

// MARK: - ProfileEditViewController

final class ProfileEditViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private let presenter: ProfileEditPresenterProtocol
    
    // MARK: - UI
    
    private lazy var avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        
        let image = UIImageView.baseAvatarImage()
        image.image = UIImage(resource: .joaquinPhoenix)
        button.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: button.topAnchor),
            image.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])
        
        button.addTarget(self, action: #selector(tapAvatar), for: .touchUpInside)
        return button
    }()
    
    private lazy var editIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(resource: .foto)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    private lazy var nameTextView: UITextView = {
        let textView = UITextView.baseTextView()
        return textView
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView.stackVerticalEditProfile(labels: "Имя", field: nameTextView)
        return stackView
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView.baseTextView()
        return textView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView.stackVerticalEditProfile(labels: "Описание", field: descriptionTextView)
        return stackView
    }()
    
    private lazy var siteTextView: UITextView = {
        let textView = UITextView.baseTextView()
        return textView
    }()
    
    private lazy var siteStackView: UIStackView = {
        let stackView = UIStackView.stackVerticalEditProfile(labels: "Сайт", field: siteTextView)
        return stackView
    }()
    
    private lazy var bigStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameStackView,
            descriptionStackView,
            siteStackView
        ])
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    //логика пока не реализована, кнопка скрыта
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = .blackApp
        button.tintColor = .whiteApp
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Initializers
    
    init(presenter: ProfileEditPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteApp
        setupNavigationBar()
        addSubviews()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = .backButton(
            target: self,
            action: #selector(tapBackButton)
        )
    }
    
    private func addSubviews() {
        [avatarButton, editIcon, bigStackView,saveButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        [avatarButton, editIcon, bigStackView, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            avatarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            editIcon.widthAnchor.constraint(equalToConstant: 22.57),
            editIcon.heightAnchor.constraint(equalToConstant: 22.57),
            editIcon.bottomAnchor.constraint(equalTo: avatarButton.bottomAnchor),
            editIcon.trailingAnchor.constraint(equalTo: avatarButton.trailingAnchor),
            
            bigStackView.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: 24),
            bigStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bigStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.5),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.5),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func tapBackButton() {
        presenter.didTapBack()
    }
    
    @objc private func tapAvatar() {
        presenter.didTapAvatar()
    }
    
    @objc private func tapSaveButton() {
        print("сохранение и выход")
    }
}

// MARK: - ProfileEditViewProtocol

extension ProfileEditViewController: ProfileEditViewProtocol {
    
    func showExitAlert() {
        let alert = UIAlertController(
            title: "Уверены, что хотите выйти?",
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Остаться", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выйти", style: .default) { [weak self] _ in
            self?.presenter.didTapExit()
        })
        present(alert, animated: true)
    }
    
    func showAvatarAlert() {
        let alert = UIAlertController(title: "Фото профиля", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Изменить фото", style: .default) { [weak self] _ in
            self?.presenter.didSelectChangePhoto()
        })
        
        alert.addAction(UIAlertAction(title: "Удалить фото", style: .destructive) { [weak self] _ in
            self?.presenter.didSelectDeletePhoto()
        })
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))
        present(alert, animated: true)
    }
    
    func showPhotoLinkAlert() {
        let alert = UIAlertController(title: "Ссылка на фото", message: nil, preferredStyle: .alert)       
        alert.addTextField { textField in
            textField.placeholder = "Введите ссылку на фото"
            textField.keyboardType = .URL
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default) { [weak alert] _ in
            if let text = alert?.textFields?.first?.text {
                print("Введена ссылка: \(text)")
            }
        })
        present(alert, animated: true)
    }

    
    func closeSave() {
        navigationController?.popViewController(animated: true)
    }
    
    func showProfile(model: ProfileEditModel) {
        nameTextView.text = model.name
        descriptionTextView.text = model.description
        siteTextView.text = model.site
    }
    
}
