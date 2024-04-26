//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 12.04.2024.
//

import UIKit
import Kingfisher

protocol EditProfileViewControllerProtocol: AnyObject {
    func setProfile(profile: Profile)
    func updateAvatar(url: URL, options: Kingfisher.KingfisherOptionsInfo?)
}

final class EditProfileViewController: UIViewController {
    //MARK:  - Public Properties
    var presenter: EditProfilePresenter?
    weak var editProfilePresenterDelegate: EditProfilePresenterDelegate?
    
    //MARK:  - Private Properties
    private var newAvatarURL: String?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "ypBlack")
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(Self.closeButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileEditImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 35
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var changeImageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProMedium10
        label.textColor = UIColor(named: "ypWhite")
        label.text = "Сменить фото"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        let action = UITapGestureRecognizer(
            target: self,
            action: #selector(changeImageDidTap(_:))
        )
        label.addGestureRecognizer(action)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var loadAvatarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProRegular17
        label.textColor = UIColor(named: "ypBlack")
        label.text = "Загрузить изображение"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProBold22
        label.textColor = UIColor(named: "ypBlack")
        label.text = "Имя"
        return label
    }()
    
    private lazy var nameTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor(named: "ypLightGray")
        textView.font = UIFont.sfProRegular17
        textView.textColor = UIColor(named: "ypBlack")
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(
            top: 11,
            left: 16,
            bottom: 11,
            right: 16
        )
        textView.delegate = self
        return textView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProBold22
        label.textColor = UIColor(named: "ypBlack")
        label.text = "Описание"
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor(named: "ypLightGray")
        textView.font = UIFont.sfProRegular17
        textView.textColor = UIColor(named: "ypBlack")
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(
            top: 11,
            left: 16,
            bottom: 11,
            right: 16
        )
        textView.delegate = self
        return textView
    }()
    
    private let siteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProBold22
        label.textColor = UIColor(named: "ypBlack")
        label.text = "Сайт"
        return label
    }()
    
    private lazy var siteTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor(named: "ypLightGray")
        textView.font = UIFont.sfProRegular17
        textView.textColor = UIColor(named: "ypBlack")
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(
            top: 11,
            left: 16,
            bottom: 11,
            right: 16
        )
        textView.delegate = self
        return textView
    }()
    
    // MARK: - Initializers
    init(presenter: EditProfilePresenter?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    @objc func closeButtonTap() {
        let name = nameTextView.text
        let description = descriptionTextView.text
        let website = siteTextView.text
        presenter?.updateProfile(
            name: name,
            description: description,
            website: website,
            newAvatarURL: newAvatarURL
        )
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func changeImageDidTap(_ sender: UITapGestureRecognizer) {
        loadAvatarLabel.isHidden = false
        
        let alert = UIAlertController(
            title: "Загрузить изображение",
            message: "Вставьте ссылку на изображение",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Вставьте ссылку: "
        }

        alert.addAction(
            UIAlertAction(
                title: "ОK",
                style: .default) { [weak self] _ in
                    guard
                    let self = self,
                    let textField = alert.textFields?[0],
                    let URL = textField.text
                else { return }

                if validateURLFormat(urlString: URL) {
                    self.loadAvatarLabel.text = URL
                    self.newAvatarURL = URL
                } else {
                    let wrongURL = UIAlertController(
                        title: "Ccылка недействительна",
                        message: "Проверьте верность ссылки",
                        preferredStyle: .alert)
                    wrongURL.addAction(
                        UIAlertAction(
                            title: "ОK",
                            style: .cancel
                        ) { _ in
                            wrongURL.dismiss(animated: true)
                        }
                    )
                    self.present(wrongURL, animated: true)
                }
                alert.dismiss(animated: true)
            }
        )
        self.present(alert, animated: true)
    }
    
    @objc func handleTapGesture() {
        nameTextView.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        siteTextView.resignFirstResponder()
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingScreenElements()
        customizingTheLayoutOfScreenElements()
        presenter?.viewDidLoad()
    }
    //MARK: - Private Methods
    private func customizingScreenElements() {
        view.backgroundColor = .systemBackground
        [closeButton, profileEditImage, loadAvatarLabel, changeImageLabel, nameLabel, nameTextView, descriptionLabel, descriptionTextView, siteLabel, siteTextView].forEach {view.addSubview($0)}
        [closeButton, profileEditImage, loadAvatarLabel, changeImageLabel,nameLabel, nameTextView, descriptionLabel, descriptionTextView, siteLabel, siteTextView].forEach {($0).translatesAutoresizingMaskIntoConstraints = false}
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGesture)
        )
        view.addGestureRecognizer(tapGesture)
    }
    
    private func customizingTheLayoutOfScreenElements() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            
            profileEditImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            profileEditImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileEditImage.widthAnchor.constraint(equalToConstant: 70),
            profileEditImage.heightAnchor.constraint(equalToConstant: 70),
            
            loadAvatarLabel.topAnchor.constraint(equalTo: profileEditImage.bottomAnchor, constant: 11),
            loadAvatarLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            changeImageLabel.centerXAnchor.constraint(equalTo: profileEditImage.centerXAnchor),
            changeImageLabel.centerYAnchor.constraint(equalTo: profileEditImage.centerYAnchor),
            changeImageLabel.widthAnchor.constraint(equalToConstant: 45),
            
            nameLabel.topAnchor.constraint(equalTo: profileEditImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextView.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            
            siteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            siteLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            siteTextView.topAnchor.constraint(equalTo: siteLabel.bottomAnchor, constant: 8),
            siteTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            siteTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            siteTextView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func validateURLFormat(urlString: String?) -> Bool {
        guard
            let urlString = urlString,
            let url = NSURL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url as URL)
    }
}

// MARK: - EditProfileViewControllerProtocol
extension EditProfileViewController: EditProfileViewControllerProtocol {
    func setProfile(profile: Profile) {
        nameTextView.text = profile.name
        descriptionTextView.text = profile.description
        siteTextView.text = profile.website
        if let avatarURLString = profile.avatar {
            let avatarURL = URL(string: avatarURLString)
            if let url = avatarURL {
                updateAvatar(url: url, options: nil)
            } else {
                print("Avatar is nil")
            }
        }
    }
    
    func updateAvatar(url: URL, options: Kingfisher.KingfisherOptionsInfo?) {
        profileEditImage.kf.indicatorType = .activity
        profileEditImage.kf.setImage(
            with: url,
            options: options)
    }
}

// MARK: - UITextViewDelegate
extension EditProfileViewController: UITextViewDelegate {
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

