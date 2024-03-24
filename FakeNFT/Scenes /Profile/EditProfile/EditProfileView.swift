//
//  EditProfileView.swift
//  FakeNFT
//
//  Created by Dinara on 24.03.2024.
//

import SnapKit
import UIKit

// MARK: - EditProfileView UIView
final class EditProfileView: UIView {
    // MARK: - Properties
    private var viewController: EditProfileViewController
    private let presenter: ProfilePresenterProtocol

    // MARK: - UI
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "ypUniBlack")
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var changeImageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor(named: "ypUniWhite")
        label.text = L10n.Profile.changeImage
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        let action = UIGestureRecognizer(
            target: self,
            action: #selector(changeImageDidTap)
        )
        label.addGestureRecognizer(action)
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar_icon")
        // заменить моковые данные
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var loadAvatarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(named: "ypUniBlack")
        label.text = L10n.Profile.loadAvatar
        label.textAlignment = .center
        return label
    }()

    private lazy var avatarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.name
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = UIColor(named: "ypUniBlack")
        textField.backgroundColor = UIColor(named: "ypLightGray")
        textField.text = "Joaquin Phoenix"
        // заменить моковые данные
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        let leftView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 16,
                height: textField.frame.height
            )
        )
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.delegate = self
        return textField
    }()

    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.description
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.textColor = UIColor(named: "ypUniBlack")
        textView.backgroundColor = UIColor(named: "ypLightGray")
        textView.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        // заменить моковые данные
        textView.layer.cornerRadius = 12
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

    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.site
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var siteTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = UIColor(named: "ypUniBlack")
        textField.backgroundColor = UIColor(named: "ypLightGray")
        textField.text = "Joaquin Phoenix.com"
        // заменить моковые данные
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        let leftView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 16,
                height: textField.frame.height
            )
        )
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.delegate = self
        return textField
    }()

    private lazy var siteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var generalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()

    // MARK: - Init
    init(
        frame: CGRect,
        viewController: EditProfileViewController,
        presenter: ProfilePresenterProtocol
    ) {
        self.viewController = viewController
        self.presenter = presenter
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EditProfileView {
    // MARK: - Setup Views
    func setupViews() {
        self.backgroundColor = .systemBackground

        [nameLabel,
         nameTextField
        ].forEach {
            nameStackView.addArrangedSubview($0)
        }

        [descriptionLabel,
         descriptionTextView
        ].forEach {
            descriptionStackView.addArrangedSubview($0)
        }

        [siteLabel,
         siteTextField
        ].forEach {
            siteStackView.addArrangedSubview($0)
        }

        [nameStackView,
         descriptionStackView,
         siteStackView
        ].forEach {
            generalStackView.addArrangedSubview($0)
        }

        [closeButton,
         avatarImageView,
         changeImageLabel,
         loadAvatarLabel,
         generalStackView
        ].forEach {
            self.addSubview($0)
        }
    }

    // MARK: - Setup Constraints
    func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.trailing.equalToSuperview().offset(-23)
            make.size.equalTo(19)
        }

        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }

        changeImageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView.snp.centerY)
            make.centerX.equalTo(avatarImageView.snp.centerX)
        }

        loadAvatarLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(15)
            make.centerX.equalTo(avatarImageView.snp.centerX)
            make.bottom.equalTo(generalStackView.snp.top).offset(-11)
        }

        nameTextField.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(46)
        }

        siteTextField.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(46)
        }

        generalStackView.snp.makeConstraints { make in
            make.top.equalTo(loadAvatarLabel.snp.bottom).offset(11)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-196)
        }
    }

    // MARK: - Actions
    @objc func closeButtonDidTap() {
        print("Close button did tap")
    }

    @objc func changeImageDidTap() {
        print("Change image did tap")
    }
}

extension EditProfileView: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
