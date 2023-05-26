//
//  EditProfileViewController.swift
//  FakeNFT
//

import UIKit
import Kingfisher

final class EditProfileViewController: UIViewController {

    var viewModel: ProfileViewModelProtocol?
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
        button.kf.setBackgroundImage(with: viewModel?.avatarURLObservable.wrappedValue,
                           for: .normal, placeholder: UIImage(named: "AvatarPlaceholder"),
                           options: [.processor(processor)])
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFill
        button.setTitle(NSLocalizedString("changePhoto", comment: "Change avatar button label text"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.titleLabel?.textColor = .white
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        return button
    }()

    private lazy var nameLabel = makeLabel(text: NSLocalizedString("name", comment: "User name label"))
    private lazy var nameTextField = makeTextField(text: viewModel?.nameObservable.wrappedValue ?? "")
    private lazy var nameStackView = makeStackView(with: [nameLabel, nameTextField])

    private lazy var descriptionLabel = makeLabel(text: NSLocalizedString("description", comment: "User description label"))
    private lazy var descriptionTextView = makeTextView(text: viewModel?.descriptionObservable.wrappedValue ?? "")
    private lazy var descriptionStackView = makeStackView(with: [descriptionLabel, descriptionTextView])

    private lazy var websiteLabel = makeLabel(text: NSLocalizedString("website", comment: "User website label"))
    private lazy var websiteTextVField = makeTextField(text: viewModel?.websiteObservable.wrappedValue ?? "")
    private lazy var websiteStackView = makeStackView(with: [websiteLabel, websiteTextVField])

    private lazy var mainStackView = makeStackView(with: [nameStackView, descriptionStackView, websiteStackView],
                                                   spacing: 24)

    // MARK: - LifeCycle

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
        dismiss(animated: true)
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
        [changeAvatarButton, mainStackView].forEach { contentView.addSubview($0) }
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

            mainStackView.topAnchor.constraint(equalTo: changeAvatarButton.bottomAnchor, constant: 24),
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
