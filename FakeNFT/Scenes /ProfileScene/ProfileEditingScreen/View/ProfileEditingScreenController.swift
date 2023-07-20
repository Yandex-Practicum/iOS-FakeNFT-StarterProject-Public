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
        let button = UICreator.makeButton(action: #selector(closeTapped))
        button.setImage(UIImage(systemName: Constants.IconNames.xmark), for: .normal)
        return button
    }()
    private let profileImageView = UICreator.makeImageView(cornerRadius: 35)
    private let profileImageLabel = {
        let label = UICreator.makeLabel(text: "CHANGE_PHOTO".localized,
                                        font: UIFont.appFont(.medium, withSize: 10),
                                        color: .appWhiteOnly,
                                        backgroundColor: .appBlackOnly.withAlphaComponent(0.6),
                                        alignment: .center)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 35
        return label
    }()
    private let profileLoadImageLabel = {
        let label = UICreator.makeLabel(text: "DOWNLOAD_AN_IMAGE".localized,
                                        font: UIFont.appFont(.regular, withSize: 17))
        label.isHidden = true
        return label
    }()
    private let profileNameLabel = UICreator.makeLabel(text: "NAME".localized)
    private let profileNameTextField = UICreator.makeTextField(tag: 1)
    private let profileDescriptionLabel = UICreator.makeLabel(text: "DESCRIPTION".localized)
    private let profileDescriptionTextView = UICreator.makeTextView(withFont: UIFont.appFont(.regular,
                                                                                                    withSize: 17))
    private let profileLinkLabel = UICreator.makeLabel(text: "WEBSITE".localized)
    private let profileLinkTextField = UICreator.makeTextField(tag: 2)
    private let mainStackView = UICreator.makeStackView(distribution: .fillProportionally, andSpacing: 24)
    private let nameStackView = UICreator.makeStackView()
    private let descriptionStackView = UICreator.makeStackView()
    private let linkStackView = UICreator.makeStackView()

    convenience init(viewModel: ProfileEditingScreenViewModel, delegate: ProfileUIUpdateDelegate) {
        self.init()
        self.viewModel = viewModel
        self.delegate = delegate
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appWhite
        view.addKeyboardHiddingFeature()
        profileNameTextField.delegate = self
        profileLinkTextField.delegate = self
        profileDescriptionTextView.delegate = self
        addKeyboardShowingAndHidingFeatures()
        setupAutolayout()
        addSubviews()
        setupConstraints()
        fillUI()
        profileImageLabel.isUserInteractionEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
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
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -LocalConstants.closeButtonTrailingSpacing),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor,
                                             constant: LocalConstants.closeButtonTopSpacing),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor,
                                                  constant: LocalConstants.profileImageTopSpacing),
            profileImageView.widthAnchor.constraint(equalToConstant: LocalConstants.profileImageSize),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileImageLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            profileImageLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            profileImageLabel.widthAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileImageLabel.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileLoadImageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileLoadImageLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                                       constant: LocalConstants.loadImageLabelTopSpacing),
            profileNameTextField.heightAnchor.constraint(equalToConstant: LocalConstants.defaultHeight),
            profileDescriptionTextView.heightAnchor.constraint(equalToConstant: LocalConstants.descriprionHeight),
            profileLinkTextField.heightAnchor.constraint(equalToConstant: LocalConstants.defaultHeight),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: LocalConstants.defaultSpacing),
            mainStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                               constant: LocalConstants.mainStackViewTopSpacing),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -LocalConstants.defaultSpacing)
        ])
    }

    private func addKeyboardShowingAndHidingFeatures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeImageTapped))
        profileImageLabel.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func fillUI() {
        guard let viewModel else { return }
        let profile = viewModel.profile
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

// MARK: - ProfileEditingScreenController LocalConstants
private enum LocalConstants {

    static let closeButtonTrailingSpacing: CGFloat = 23.42
    static let closeButtonTopSpacing: CGFloat = 23.92
    static let profileImageTopSpacing: CGFloat = 29.92
    static let profileImageSize: CGFloat = 70
    static let loadImageLabelTopSpacing: CGFloat = 15
    static let defaultHeight: CGFloat = 46
    static let descriprionHeight: CGFloat = 132
    static let defaultSpacing: CGFloat = 16
    static let mainStackViewTopSpacing: CGFloat = 24
}
