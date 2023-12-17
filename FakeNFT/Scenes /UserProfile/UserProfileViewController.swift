//
// Created by Андрей Парамонов on 16.12.2023.
//

import UIKit
import Kingfisher

final class UserProfileViewController: UIViewController {
    private var viewModel: UserProfileViewModel
    private let servicesAssembler: ServicesAssembly

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backward"), for: .normal)
        button.tintColor = .textPrimary
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()

    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .left
        label.textColor = .textPrimary
        label.text = viewModel.userName
        return label
    }()

    private lazy var userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.textColor = .textPrimary
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.text = viewModel.userDescription
        return label
    }()

    private lazy var goToSiteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("UserProfile.GoToSite", comment: ""), for: .normal)
        button.setTitleColor(.textPrimary, for: .normal)
        button.addTarget(self, action: #selector(goToSiteButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.textPrimary.cgColor
        return button
    }()

    private lazy var collectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(collectionButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var collectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(format: NSLocalizedString("UserProfile.CollectionSize", comment: ""),
                            viewModel.userCollectionSize)
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        label.textColor = .textPrimary
        return label
    }()

    private lazy var collectionForwardImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "backward")
        imageView.tintColor = .textPrimary
        imageView.contentMode = .scaleAspectFit
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        return imageView
    }()

    init(viewModel: UserProfileViewModel, servicesAssembler: ServicesAssembly) {
        self.viewModel = viewModel
        self.servicesAssembler = servicesAssembler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        setupView()
    }

    private func setupBindings() {
        viewModel.openSite = { [weak self] request in
            self?.openSite(request)
        }
    }

    private func setupView() {
        view.backgroundColor = .background

        addSubviews()
        setupConstraints()
        userImageView.kf.indicatorType = .none
        userImageView.kf.setImage(
                with: viewModel.userAvatar,
                placeholder: UIImage.userPhotoPlaceholder,
                options: [.cacheSerializer(FormatIndicatedCacheSerializer.jpeg), .cacheMemoryOnly])

    }

    private func addSubviews() {
        view.addSubview(backButton)
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(userDescriptionLabel)
        view.addSubview(goToSiteButton)
        view.addSubview(collectionButton)
        collectionButton.addSubview(collectionLabel)
        collectionButton.addSubview(collectionForwardImage)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
                    backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                            constant: 9),
                    backButton.heightAnchor.constraint(equalToConstant: 24),
                    backButton.widthAnchor.constraint(equalToConstant: 24),

                    userImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 29),
                    userImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                           constant: Constants.leadingOffset),
                    userImageView.heightAnchor.constraint(equalToConstant: 70),
                    userImageView.widthAnchor.constraint(equalToConstant: 70),

                    userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
                    userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor,
                                                           constant: Constants.leadingOffset),
                    userNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                            constant: Constants.trailingOffset),

                    userDescriptionLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
                    userDescriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                                  constant: Constants.leadingOffset),
                    userDescriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                                   constant: Constants.trailingOffset),

                    goToSiteButton.topAnchor.constraint(equalTo: userDescriptionLabel.bottomAnchor, constant: 28),
                    goToSiteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                            constant: Constants.leadingOffset),
                    goToSiteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                             constant: Constants.trailingOffset),
                    goToSiteButton.heightAnchor.constraint(equalToConstant: 40),

                    collectionButton.topAnchor.constraint(equalTo: goToSiteButton.bottomAnchor, constant: 40),
                    collectionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    collectionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

                    collectionLabel.centerYAnchor.constraint(equalTo: collectionButton.centerYAnchor),
                    collectionLabel.leadingAnchor.constraint(equalTo: collectionButton.leadingAnchor,
                                                             constant: Constants.leadingOffset),
                    collectionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: collectionForwardImage.leadingAnchor,
                                                              constant: Constants.trailingOffset),

                    collectionForwardImage.centerYAnchor.constraint(equalTo: collectionButton.centerYAnchor),
                    collectionForwardImage.trailingAnchor.constraint(equalTo: collectionButton.trailingAnchor,
                                                                   constant: Constants.trailingOffset),
                    collectionForwardImage.heightAnchor.constraint(equalTo: collectionLabel.heightAnchor),
                    collectionForwardImage.widthAnchor.constraint(equalTo: collectionLabel.heightAnchor)
                ]
        )
    }

    @objc
    private func didTapBackButton() {
        dismiss(animated: false)
    }

    @objc
    private func goToSiteButtonTapped() {
        viewModel.goToSiteButtonTapped()
    }

    @objc
    private func collectionButtonTapped() {
        print("collectionButtonTapped")
    }

    private func openSite(_ request: URLRequest) {
        let vc = WebViewAssembly(servicesAssembler: servicesAssembler).build(request: request)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension UserProfileViewController {
    private enum Constants {
        static let leadingOffset: CGFloat = 16
        static let trailingOffset: CGFloat = -leadingOffset
    }
}
