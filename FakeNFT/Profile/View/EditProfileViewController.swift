//
//  EditProfileViewController.swift
//  FakeNFT
//

import UIKit
import Kingfisher
import ProgressHUD

final class EditProfileViewController: UIViewController {

    private let profileViewModel: ProfileViewModelProtocol
    private let notificationCenter = NotificationCenter.default

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)
        let buttonImage = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(buttonImage?.withTintColor(.textColorBlack, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        return button
    }()

    private lazy var changeAvatarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 35
        button.layer.masksToBounds = true
        let processor = OverlayImageProcessor(overlay: .textColorBlack, fraction: 0.6)
        button.kf.setBackgroundImage(with: profileViewModel.avatarURLObservable.wrappedValue,
                                     for: .normal,
                                     placeholder: UIImage(named: Constants.avatarPlaceholder),
                                     options: [.processor(processor)])
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFill
        button.imageView?.contentMode = .scaleAspectFill
        button.setTitle(Constants.changeAvatarButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(changeAvatarAction), for: .touchUpInside)
        return button
    }()

    private lazy var loadNewAvatarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.loadNewAvatarButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(.textColorBlack, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.isUserInteractionEnabled = false
        button.alpha = 0.0
        button.addTarget(self, action: #selector(fakeUploadAvatarAction), for: .touchUpInside)
        return button
    }()

    private lazy var nameLabel = makeLabel(text: Constants.nameLabelText)
    private lazy var nameTextField = makeTextField(text: profileViewModel.nameObservable.wrappedValue)
    private lazy var nameStackView = makeStackView(with: [nameLabel, nameTextField])

    private lazy var descriptionLabel = makeLabel(text: Constants.descriptionLabelText)
    private lazy var descriptionTextView = makeTextView(text: profileViewModel.descriptionObservable.wrappedValue)
    private lazy var descriptionStackView = makeStackView(with: [descriptionLabel, descriptionTextView])

    private lazy var websiteLabel = makeLabel(text: Constants.websiteLabelText)
    private lazy var websiteTextVField = makeTextField(text: profileViewModel.websiteObservable.wrappedValue)
    private lazy var websiteStackView = makeStackView(with: [websiteLabel, websiteTextVField])

    private lazy var mainStackView = makeStackView(with: [nameStackView, descriptionStackView, websiteStackView], spacing: 24)

    // MARK: - LifeCycle

    init(profileViewModel: ProfileViewModelProtocol) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackgroundColor
        setupConstraints()
        hideKeyboardByTap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Pivate Funcs

    @objc private func changeAvatarAction() {
        loadNewAvatarButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 1) { self.loadNewAvatarButton.alpha = 1.0 }
    }

    @objc private func fakeUploadAvatarAction() {
        UIBlockingProgressHUD.show()
        changeAvatarButton.kf.setImage(with: URL(string: Constants.mockAvatarImageURLString), for: .normal,
                                       completionHandler:  { _ in UIBlockingProgressHUD.dismiss() })
        loadNewAvatarButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1) { self.loadNewAvatarButton.alpha = 0.0 }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

    @objc private func closeButtonAction() {
        UIBlockingProgressHUD.show()
        profileViewModel.didChangeProfile(name: nameTextField.text,
                                          description: descriptionTextView.text,
                                          website: websiteTextVField.text,
                                          avatar: Constants.mockAvatarImageURLString,
                                          likes: nil) { [weak self] in
            self?.dismiss(animated: true)
            UIBlockingProgressHUD.dismiss()
        }
    }

    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .textColorBlack
        return label
    }

    private func makeTextField(text: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = text
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = .textColorBlack
        textField.backgroundColor = .lightGreyBackground
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.makeIndent(points: 16)
        textField.delegate = self
        return textField
    }

    private func makeTextView(text: String) -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textColor = .textColorBlack
        textView.backgroundColor = .lightGreyBackground
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 12
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }

    private func makeStackView(with subviews: [UIView], spacing: CGFloat = 8) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = spacing
        stackView.axis = .vertical
        return stackView
    }

    private func setupConstraints() {
        [scrollView, closeButton].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        [changeAvatarButton, loadNewAvatarButton, mainStackView].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            changeAvatarButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            changeAvatarButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            changeAvatarButton.widthAnchor.constraint(equalToConstant: 70),
            changeAvatarButton.heightAnchor.constraint(equalToConstant: 70),

            loadNewAvatarButton.topAnchor.constraint(equalTo: changeAvatarButton.bottomAnchor, constant: 12),
            loadNewAvatarButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            mainStackView.topAnchor.constraint(equalTo: loadNewAvatarButton.bottomAnchor, constant: -6),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            websiteTextVField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// MARK: - UITextFieldDelegate

extension EditProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
}
