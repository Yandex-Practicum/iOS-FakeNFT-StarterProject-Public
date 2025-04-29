//
//  EditProfileView.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 25.03.2025.
//


import UIKit

final class EditProfileView: UIView {
    
    var closeTapped: (() -> Void)?
    var avatarTapped: (() -> Void)?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        
        let image = UIImage(named: "close")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "YBlackColor")
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var profileAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var profileAvatarButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(avatarImageTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "YBlackColor")?.withAlphaComponent(0.6)
        button.setTitle(NSLocalizedString("ChangePhoto", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return button
    }()
    
    private lazy var loadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 250, height: 44)
        button.isHidden = true
        button.setTitle(NSLocalizedString("LoadImage", comment: ""), for: .normal)
        button.setTitleColor(UIColor(named: "YBlackColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(loadImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Name", comment: "")
        label.textColor = UIColor(named: "YBlackColor")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    lazy var nameTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor(named: "LightGrayColor")
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return textView
    }()
    
    private lazy var userInfoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Description", comment: "")
        label.textColor = UIColor(named: "YBlackColor")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    lazy var infoTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor(named: "LightGrayColor")
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.heightAnchor.constraint(equalToConstant: 132).isActive = true
        return textView
    }()
    
    private lazy var userSiteLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("WebSite", comment: "")
        label.textColor = UIColor(named: "YBlackColor")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    lazy var siteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor(named: "LightGrayColor")
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupKeyboardHandling()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        profileAvatar.translatesAutoresizingMaskIntoConstraints = false
        profileAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        loadImageButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        userInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoTextView.translatesAutoresizingMaskIntoConstraints = false
        userSiteLabel.translatesAutoresizingMaskIntoConstraints = false
        siteTextView.translatesAutoresizingMaskIntoConstraints = false
        
        [closeButton, profileAvatar, profileAvatarButton, loadImageButton, nameLabel, nameTextView, userInfoLabel, infoTextView, userSiteLabel, siteTextView].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.closeButtonTrailing),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.closeButtonTop),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            
            profileAvatar.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileAvatar.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: Constants.avatarTop),
            profileAvatar.widthAnchor.constraint(equalToConstant: Constants.avatarSize),
            profileAvatar.heightAnchor.constraint(equalToConstant: Constants.avatarSize),
            
            profileAvatarButton.centerXAnchor.constraint(equalTo: profileAvatar.centerXAnchor),
            profileAvatarButton.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor),
            profileAvatarButton.widthAnchor.constraint(equalToConstant: Constants.avatarButtonSize),
            profileAvatarButton.heightAnchor.constraint(equalToConstant: Constants.avatarButtonSize),
            
            loadImageButton.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: Constants.loadImageButtonTop),
            loadImageButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: Constants.nameLabelTop),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            
            nameTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.textViewTop),
            nameTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            nameTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            
            userInfoLabel.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: Constants.userInfoLabelTop),
            userInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            userInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            
            infoTextView.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: Constants.textViewTop),
            infoTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            infoTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            
            userSiteLabel.topAnchor.constraint(equalTo: infoTextView.bottomAnchor, constant: Constants.userSiteLabelTop),
            userSiteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            userSiteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            
            siteTextView.topAnchor.constraint(equalTo: userSiteLabel.bottomAnchor, constant: Constants.textViewTop),
            siteTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            siteTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding)
        ])
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func hideKeyboard() {
        endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        self.frame.origin.y = -keyboardFrame.height / 2
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.frame.origin.y = 0
    }
    
    
    @objc private func closeButtonTapped() {
        closeTapped?()
    }
    
    @objc private func loadImageButtonTapped() {
        avatarTapped?()
    }
    
    @objc private func avatarImageTapped() {
        loadImageButton.isHidden.toggle()
    }
    
}


private extension EditProfileView {
    enum Constants {
        static let closeButtonTrailing: CGFloat = -16
        static let closeButtonTop: CGFloat = 30
        static let buttonSize: CGFloat = 44
        static let avatarTop: CGFloat = 22
        static let avatarSize: CGFloat = 70
        static let avatarButtonSize: CGFloat = 70
        static let loadImageButtonTop: CGFloat = 4
        static let nameLabelTop: CGFloat = 24
        static let textViewTop: CGFloat = 8
        static let userInfoLabelTop: CGFloat = 24
        static let userSiteLabelTop: CGFloat = 24
        static let horizontalPadding: CGFloat = 16
    }
    
}
