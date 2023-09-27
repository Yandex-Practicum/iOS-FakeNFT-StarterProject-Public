//
//  DevelopersView.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 22.09.2023.
//
import Kingfisher
import UIKit

struct Developers {
    let name: String
    let image: String
    let telegram: String
    let email: String
    let description: String
}

final class DevelopersView: UIView {
    // MARK: - Properties

    private lazy var devsImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.kf.indicatorType = .activity
        imageView.backgroundColor = .clear
        imageView.accessibilityIdentifier = AccessibilityIdentifiers.devsImageView
        return imageView
    }()

    private lazy var devsNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя: "
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 2
        label.accessibilityIdentifier = AccessibilityIdentifiers.devsNameLabel
        return label
    }()

    private lazy var telegramLabel: UILabel = {
        let label = UILabel()
        label.text = "Telegram: "
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.isUserInteractionEnabled = true
        label.accessibilityIdentifier = AccessibilityIdentifiers.telegramLabel

        let tap = UITapGestureRecognizer(target: self, action: #selector(telegrammButtonTapped))

       // label.addGestureRecognizer(tap)

        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-mail: "
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.accessibilityIdentifier = AccessibilityIdentifiers.emailLabel

        let tap = UITapGestureRecognizer(target: self, action: #selector(emailButtonTapped))
        // label.addGestureRecognizer(tap)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [devsNameLabel, emailLabel, telegramLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.accessibilityIdentifier = AccessibilityIdentifiers.stackView
        return stack
    }()

    private lazy var devsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = AccessibilityIdentifiers.devsDescriptionLabel
        return label
    }()

    private var devsEmail: String?
    private var devsTelegram: String?

    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
        layouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Layouts

    private func layouts() {
        self.addSubview(devsImageView)
        self.addSubview(stackView)
        self.addSubview(devsDescriptionLabel)

        NSLayoutConstraint.activate([
            devsImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            devsImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            devsImageView.heightAnchor.constraint(equalToConstant: 120),
            devsImageView.widthAnchor.constraint(equalTo: devsImageView.heightAnchor),

            stackView.leadingAnchor.constraint(equalTo: devsImageView.trailingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: devsImageView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            devsDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            devsDescriptionLabel.topAnchor.constraint(equalTo: devsImageView.bottomAnchor, constant: 16),
            devsDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            devsDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Methods

    func configure(with devs: Developers) {
        let imageUrl = URL(string: devs.image)
        let placeHolder = UIImage(named: "placeHolder")
        devsImageView.kf.setImage(
            with: imageUrl,
            placeholder: placeHolder,
            options: [.scaleFactor(UIScreen.main.scale),
                      .transition(.fade(1))]
        )
        devsDescriptionLabel.text = devs.description
        telegramLabel.text = devs.telegram
        emailLabel.text = devs.email

        devsNameLabel.text = devs.name
        self.devsEmail = devs.email
        self.devsTelegram = devs.telegram

        setupEmailLabel(with: devs.email)
        setupTelegrammLabel(with: devs.telegram)

    }
    // MARK: - Private Methods

    private func setupEmailLabel(with text: String) {
        let emailAttachment = NSTextAttachment()
        if let emailImage = UIImage(systemName: "envelope.fill") {
            emailAttachment.image = emailImage.withRenderingMode(.alwaysTemplate).withTintColor(.ypBlack ?? .black)
        }
        let emailIcon = NSAttributedString(attachment: emailAttachment)
        let emailText = NSMutableAttributedString(string: "E-mail: \n\(text) ")
        emailText.append(emailIcon)
        emailLabel.attributedText = emailText
    }

    private func setupTelegrammLabel(with text: String) {
        let telegramAttachment = NSTextAttachment()
        if let telegramImage = UIImage(systemName: "paperplane.fill") {
            telegramAttachment.image = telegramImage.withRenderingMode(.alwaysTemplate).withTintColor(.ypBlack ?? .black)

        }
        let telegramIcon = NSAttributedString(attachment: telegramAttachment)
        let telegramText = NSMutableAttributedString(string: "Telegram: \n\(text) ")
        telegramText.append(telegramIcon)
        telegramLabel.attributedText = telegramText
    }

    @objc private func telegrammButtonTapped() {
        guard let devsTelegram = self.devsTelegram else { return }
        if let url = URL(string: "tg://resolve?domain=\(devsTelegram)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                if let webURL = URL(string: "https://t.me/\(devsTelegram)") {
                    UIApplication.shared.open(webURL)
                }
            }
        }
    }

    @objc private func emailButtonTapped() {
        guard let devsEmail = self.devsEmail else { return }
        if let url = URL(string: "mailto:\(devsEmail)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                if let webURL = URL(string: "https://mail.google.com/") {
                    UIApplication.shared.open(webURL)
                }
            }
        }
    }
}
