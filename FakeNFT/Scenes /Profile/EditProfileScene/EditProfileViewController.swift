//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 21.01.2024.
//

import UIKit

protocol EditProfileViewProtocol: AnyObject {
    func updateProfile(with: ProfileUIModel)
}

final class EditProfileViewController: UIViewController {
    
    // MARK: Properties & UI Elements
    var currentProfile: ProfileUIModel? {
        didSet {
            updateUIProfile()
        }
    }
    
    private lazy var closeButton: UIButton = {
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypBlack
        button.setImage(
            UIImage(systemName: Constants.closeButton, withConfiguration: config),
            for: .normal
        )
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = Constants.cornerRadius
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private lazy var dimmingForAvatarImage: UIView = {
        let view = UIView(frame: avatarImage.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.dimmingModel
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var labelForAvatarImage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .sfProMedium10
        label.textColor = .ypWhiteUn
        label.text = Constants.textForAvatarLabel
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var nameStack: StackViewForEditProfile = {
        let name = StackViewForEditProfile(
            labelText: Constants.nameLabelText,
            textContent: Constants.placeholdTextViewText
        )
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private lazy var descriptionStack: StackViewForEditProfile = {
        let descript = StackViewForEditProfile(
            labelText: Constants.descriptionLabelText,
            textContent: Constants.placeholdTextViewText
        )
        descript.translatesAutoresizingMaskIntoConstraints = false
        return descript
    }()
    
    private lazy var webLinkStack: StackViewForEditProfile = {
        let web = StackViewForEditProfile(
            labelText: Constants.webLinkLabelText,
            textContent: Constants.placeholdTextViewText
        )
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubView()
        applyConstraint()
    }
    
    private func addSubView() {
        view.addSubview(scrollView)
        avatarImage.addSubview(dimmingForAvatarImage)
        dimmingForAvatarImage.addSubview(labelForAvatarImage)
        [closeButton, avatarImage, nameStack, descriptionStack, webLinkStack].forEach { scrollView.addSubview($0) }
    }
    
    private func applyConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            closeButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.baseOffset16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.baseOffset16),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.baseSize42),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.baseSize42),
            avatarImage.heightAnchor.constraint(equalToConstant: Constants.baseSize70),
            avatarImage.widthAnchor.constraint(equalToConstant: Constants.baseSize70),
            avatarImage.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: Constants.topIdent),
            avatarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dimmingForAvatarImage.heightAnchor.constraint(equalToConstant: Constants.baseSize70),
            dimmingForAvatarImage.widthAnchor.constraint(equalToConstant: Constants.baseSize70),
            dimmingForAvatarImage.centerXAnchor.constraint(equalTo: avatarImage.centerXAnchor),
            dimmingForAvatarImage.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            labelForAvatarImage.heightAnchor.constraint(equalToConstant: Constants.labelSizeH),
            labelForAvatarImage.widthAnchor.constraint(equalToConstant: Constants.labelSizeW),
            labelForAvatarImage.centerXAnchor.constraint(equalTo: dimmingForAvatarImage.centerXAnchor),
            labelForAvatarImage.centerYAnchor.constraint(equalTo: dimmingForAvatarImage.centerYAnchor),
            nameStack.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: Constants.baseOffset24),
            nameStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.baseOffset16),
            nameStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.baseOffset16),
            descriptionStack.topAnchor.constraint(equalTo: nameStack.bottomAnchor, constant: Constants.baseOffset24),
            descriptionStack.leadingAnchor.constraint(equalTo: nameStack.leadingAnchor),
            descriptionStack.trailingAnchor.constraint(equalTo: nameStack.trailingAnchor),
            webLinkStack.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor, constant: Constants.baseOffset24),
            webLinkStack.leadingAnchor.constraint(equalTo: descriptionStack.leadingAnchor),
            webLinkStack.trailingAnchor.constraint(equalTo: descriptionStack.trailingAnchor),
            webLinkStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.baseOffset24)
        ])
    }
    
    private func updateUIProfile() {
        // TODO: Обновляем профиль
    }
    
    // MARK: Actions
    @objc private func didTapCloseButton() {
        // TODO: Выходим из меню редактирования, сохраняем изменения
    }
}

private extension EditProfileViewController {
    struct Constants {
        // UI Helper
        static let closeButton = "xmark"
        static let textForAvatarLabel = "Сменить фото"
        static let nameLabelText = "Имя"
        static let descriptionLabelText = "Описание"
        static let webLinkLabelText = "Сайт"
        static let placeholdTextViewText = ""
        static let cornerRadius: CGFloat = 35
        static let dimmingModel = UIColor(hexString: "1A1B22").withAlphaComponent(0.5)
        // Constraint
        static let baseSize70: CGFloat = 70
        static let baseSize42: CGFloat = 42
        static let topIdent: CGFloat = 22
        static let labelSizeW: CGFloat = 45
        static let labelSizeH: CGFloat = 24
        static let baseOffset24: CGFloat = 24
        static let baseOffset16: CGFloat = 16
    }
}
