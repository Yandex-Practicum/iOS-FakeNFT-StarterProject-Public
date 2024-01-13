//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 13.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: Properties & UI Elemenst
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 35
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "person.circle")
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .sfProBold22
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .sfProRegular13
        label.textColor = .ypBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var webLinkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlueUn
        label.font = .sfProRegular15
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(
            systemName: "square.and.pencil",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        )
        button.setImage(image, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var userStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubView()
        applyConstraint()
        
        // test stub
        nameLabel.text = "Ivan Ivanov"
        descriptionLabel.text = "Всем привет \n и пока!"
        webLinkLabel.text = "https://github.com/iamjohansson"
    }
    
    // MARK: Methods
    
    private func addSubView() {
        [avatarImage, nameLabel].forEach { userStack.addArrangedSubview($0) }
        [editButton, userStack, descriptionLabel, webLinkLabel].forEach { view.addSubview($0) }
    }
    
    private func applyConstraint() {
        NSLayoutConstraint.activate([
            editButton.heightAnchor.constraint(equalToConstant: 44),
            editButton.widthAnchor.constraint(equalToConstant: 44),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -7),
            userStack.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            userStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            userStack.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            descriptionLabel.topAnchor.constraint(equalTo: userStack.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: userStack.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: userStack.trailingAnchor),
            webLinkLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            webLinkLabel.leadingAnchor.constraint(equalTo: userStack.leadingAnchor),
            webLinkLabel.trailingAnchor.constraint(equalTo: userStack.trailingAnchor),
            webLinkLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    // MARK: Actions
    @objc private func didTapEditButton() {
        // TODO: на экран редактирования
    }
}
