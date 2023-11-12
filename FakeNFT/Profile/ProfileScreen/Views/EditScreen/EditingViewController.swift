import UIKit
import Kingfisher

final class EditingViewController: UIViewController {

    // MARK: - UI properties

    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .nftBackgroundUniversal
        view.layer.cornerRadius = 35
        return view
    }()

    private lazy var exitButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .nftBlack
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        let title = NSLocalizedString("EditingViewController.changePhoto", comment: "")
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties

    private lazy var alertService: AlertServiceProtocol = {
        return AlertService(viewController: self)
    }()

    private let viewModel: ProfileViewModelProtocol
    private let viewFactory = ViewFactory()

    private lazy var nameLabel = viewFactory.createTextLabel()
    private lazy var nameTextView = viewFactory.createTextView()
    private lazy var descriptionLabel = viewFactory.createTextLabel()
    private lazy var descriptionTextView = viewFactory.createTextView()
    private lazy var webSiteLabel = viewFactory.createTextLabel()
    private lazy var webSiteTextView = viewFactory.createTextView()

    // MARK: - Lifecycle

    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupDelegates()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.saveUserProfile()
    }

    // MARK: - Actions

    @objc
    private func exitButtonTapped() {
        dismiss(animated: true)
    }

    @objc func changePhotoTapped() {
        alertService.showChangePhotoURLAlert(with: "Введите URL",
                                             message: nil,
                                             textFieldPlaceholder: "URL изображения") { [weak self] urlText in
            guard let self = self else { return }
            if let urlText = urlText,
               let url = URL(string: urlText) {
                self.viewModel.updateImageURL(with: url)
            } else {
                self.alertService.showAvatarChangeError()
            }
        }
    }

    // MARK: - Methods

    private func bind() {
        viewModel.observeUserProfileChanges { [weak self] (profile: UserProfileModel?) in
            guard
                let self = self,
                let profile = profile
            else { return }
            self.configureUIElements(with: profile)
        }
    }

    private func setupDelegates() {
        [nameTextView, descriptionTextView, webSiteTextView].forEach { $0.delegate = self }
    }

    private func configureUIElements(with profile: UserProfileModel) {
        DispatchQueue.main.async { [weak self] in
            self?.userPhotoImageView.kf.setImage(with: URL(string: profile.avatar))
            self?.nameLabel.text = NSLocalizedString("EditingViewController.name", comment: "")
            self?.nameTextView.text = profile.name
            self?.descriptionLabel.text = NSLocalizedString("EditingViewController.description", comment: "")
            self?.descriptionTextView.text = profile.description
            self?.webSiteLabel.text = NSLocalizedString("EditingViewController.site", comment: "")
            self?.webSiteTextView.text = profile.website
        }
    }

    // MARK: - Layout methods

    private func setupViews() {
        view.backgroundColor = .white
        view.addTapGestureToHideKeyboard()

        [exitButton, userPhotoImageView, overlayView,
         changePhotoButton, nameLabel, nameTextView,
         descriptionLabel, descriptionTextView, webSiteLabel,
         webSiteTextView].forEach { view.addViewWithNoTAMIC($0) }

        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exitButton.widthAnchor.constraint(equalToConstant: 42),
            exitButton.heightAnchor.constraint(equalToConstant: 42),

            userPhotoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 70),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 70),

            overlayView.topAnchor.constraint(equalTo: userPhotoImageView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor),

            changePhotoButton.topAnchor.constraint(equalTo: overlayView.topAnchor),
            changePhotoButton.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor),
            changePhotoButton.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            changePhotoButton.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: 24),

            nameTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nameTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),

            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: 24),

            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),

            webSiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            webSiteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            webSiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),

            webSiteTextView.leadingAnchor.constraint(equalTo: webSiteLabel.leadingAnchor),
            webSiteTextView.trailingAnchor.constraint(equalTo: webSiteLabel.trailingAnchor),
            webSiteTextView.topAnchor.constraint(equalTo: webSiteLabel.bottomAnchor, constant: 8)

        ])
    }
}

// MARK: - UITextViewDelegate

extension EditingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            switch textView {
            case nameTextView:
                viewModel.updateName(text)
            case descriptionTextView:
                viewModel.updateDescription(text)
            case webSiteTextView:
                viewModel.updateWebSite(text)
            default:
                break
            }
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

