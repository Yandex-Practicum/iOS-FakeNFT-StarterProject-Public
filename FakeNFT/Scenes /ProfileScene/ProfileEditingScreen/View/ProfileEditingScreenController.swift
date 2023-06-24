//
//  ProfileEditingScreenController.swift
//  FakeNFT
//
//  Created by Илья Валито on 20.06.2023.
//

import UIKit

// MARK: - ProfileEditingScreenController
final class ProfileEditingScreenController: UIViewController {

    // MARK: - Properties and Initializers
    private var viewModel: ProfileEditingScreenViewModel?
    private weak var delegate: ProfileUIUpdateDelegate?

    private let closeButton = {
        let button = UICreator.shared.makeButton(action: #selector(closeTapped))
        button.setImage(UIImage(systemName: Constants.IconNames.xmark), for: .normal)
        return button
    }()
    private let profileImageView = UICreator.shared.makeImageView(cornerRadius: 35)
    private let profileImageLabel = {
        let label = UICreator.shared.makeLabel(text: "CHANGE_PHOTO".localized,
                                               font: UIFont.appFont(.medium, withSize: 10),
                                               color: .appWhiteOnly,
                                               backgroundColor: .appBlackOnly.withAlphaComponent(0.6),
                                               alignment: .center)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 35
        return label
    }()
    private let profileLoadImageLabel = {
        let label = UICreator.shared.makeLabel(text: "DOWNLOAD_AN_IMAGE".localized,
                                               font: UIFont.appFont(.regular, withSize: 17))
        label.isHidden = true
        return label
    }()
    private let profileNameLabel = UICreator.shared.makeLabel(text: "NAME".localized)
    private let profileNameTextField = UICreator.shared.makeTextField(tag: 1)
    private let profileDescriptionLabel = UICreator.shared.makeLabel(text: "DESCRIPTION".localized)
    private let profileDescriptionTextView = UICreator.shared.makeTextView(withFont: UIFont.appFont(.regular,
                                                                                                    withSize: 17))
    private let profileLinkLabel = UICreator.shared.makeLabel(text: "WEBSITE".localized)
    private let profileLinkTextField = UICreator.shared.makeTextField(tag: 2)
    private let mainStackView = UICreator.shared.makeStackView(distribution: .fillProportionally, andSpacing: 24)
    private let nameStackView = UICreator.shared.makeStackView()
    private let descriptionStackView = UICreator.shared.makeStackView()
    private let linkStackView = UICreator.shared.makeStackView()

    convenience init(forProfile profile: ProfileModel, delegate: ProfileUIUpdateDelegate) {
        self.init()
        self.viewModel = ProfileEditingScreenViewModel(profileToEdit: profile)
        self.delegate = delegate
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        view.addKeyboardHiddingFeature()
        profileNameTextField.delegate = self
        profileLinkTextField.delegate = self
        profileDescriptionTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        view.backgroundColor = .appWhite
        setupAutolayout()
        addSubviews()
        setupConstraints()
        fillUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeImageTapped))
        profileImageLabel.isUserInteractionEnabled = true
        profileImageLabel.addGestureRecognizer(tap)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateUI()
    }
}

// MARK: - Helpers
extension ProfileEditingScreenController {

    @objc private func keyboardWillShow(notification: NSNotification) {
        // swiftlint:disable:next line_length
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if profileDescriptionTextView.isFirstResponder || profileLinkTextField.isFirstResponder {
                if view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height - (view.frame.height < 700 ? 0 : 80)
                }
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0

    }

    @objc private func closeTapped() {
        self.dismiss(animated: true)
    }

    @objc private func changeImageTapped() {
        let alert = UIAlertController(title: "PHOTO_CHANGING".localized,
                                      message: "ENTER_A_LINK_TO_A_NEW_PHOTO".localized, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { [weak self, weak alert] _ in
            guard let self,
                  let alert else { return }
            if let textField = alert.textFields?[0],
               let link = textField.text {
                self.viewModel?.updateAvatar(withLink: link)
                self.profileImageView.loadImage(urlString: link)
                self.profileLoadImageLabel.isHidden = false
            }
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .destructive))
        self.present(alert, animated: true, completion: nil)
    }

    private func setupAutolayout() {
        closeButton.toAutolayout()
        profileImageView.toAutolayout()
        profileImageLabel.toAutolayout()
        profileLoadImageLabel.toAutolayout()
        profileDescriptionTextView.toAutolayout()
        mainStackView.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(closeButton)
        view.addSubview(profileImageView)
        view.addSubview(profileImageLabel)
        view.addSubview(profileLoadImageLabel)
        nameStackView.addArrangedSubview(profileNameLabel)
        nameStackView.addArrangedSubview(profileNameTextField)
        mainStackView.addArrangedSubview(nameStackView)
        descriptionStackView.addArrangedSubview(profileDescriptionLabel)
        descriptionStackView.addArrangedSubview(profileDescriptionTextView)
        mainStackView.addArrangedSubview(descriptionStackView)
        linkStackView.addArrangedSubview(profileLinkLabel)
        linkStackView.addArrangedSubview(profileLinkTextField)
        mainStackView.addArrangedSubview(linkStackView)
        view.addSubview(mainStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23.42),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 23.92),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 29.92),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileImageLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            profileImageLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            profileImageLabel.widthAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileImageLabel.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileLoadImageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileLoadImageLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15),
            profileNameTextField.heightAnchor.constraint(equalToConstant: 46),
            profileDescriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            profileLinkTextField.heightAnchor.constraint(equalToConstant: 46),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func fillUI() {
        guard let viewModel else { return }
        let profile = viewModel.giveData()
        profileImageView.loadImage(urlString: profile?.avatar)
        profileNameTextField.text = profile?.name
        profileDescriptionTextView.text = profile?.description
        profileLinkTextField.text = profile?.website
    }
}

// MARK: - UITextFieldDelegate
extension ProfileEditingScreenController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1: viewModel?.updateName(withName: textField.text ?? "")
        case 2: viewModel?.updateWebsite(withLink: textField.text ?? "")
        default: return
        }
    }
}

// MARK: - UITextViewDelegate
extension ProfileEditingScreenController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel?.updateDescription(withDescription: textView.text ?? "")
    }
}
