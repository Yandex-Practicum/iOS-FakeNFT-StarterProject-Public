import UIKit
import WebKit

final class UserCardViewController: UIViewController {
	
	// MARK: Public properties
	
	var viewModel: UserCardViewModel?
	
	// MARK: Private UI Properties
	
	private lazy var backButton = {
		let image = UIImage(systemName: "chevron.backward")
		let button = UIButton()
		
		button.setImage(image, for: .normal)
		button.tintColor = .textColor
		button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
		
		return UIBarButtonItem(customView: button)
	}()
	
	private lazy var avatar = {
		let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = view.frame.width / 2
		view.clipsToBounds = true
		
		guard let viewModel else {
			return view
		}
		
		let avatarUrl = URL(string: viewModel.user.avatar)
		let placeholderAvatarImage = UIImage(named: "UserAvatarPlaceholder")
		view.kf.setImage(with: avatarUrl, placeholder: placeholderAvatarImage)
		
		return view
	}()
	
	private lazy var nameLabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .textColor
		label.textAlignment = .left
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.text = viewModel?.user.name
		
		return label
	}()
	
	private lazy var descriptionLabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .textColor
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.numberOfLines = 0
		label.text = viewModel?.user.description
		
		return label
	}()
	
	private lazy var navigateToUserWebsiteButton = {
		let button = UIButton()
		
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 16
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.textColor.cgColor
		button.setTitle(
			NSLocalizedString(
				"Statistics.UserCard.NavigateToUserWebsite",
				comment: ""
			), for: .normal
		)
		button.setTitleColor(.textColor, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
		button.addTarget(
			self,
			action: #selector(navigateToUserWebsiteButtonDidTap),
			for: .touchUpInside
		)
		
		return button
	}()
	
	private lazy var nftCollectionButton = {
		let button = UIButton()
		let caption = NSLocalizedString(
			"Statistics.UserCard.NFTCollection",
				comment: ""
		) + " (\(viewModel?.user.nfts.count ?? 0))"
		
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitleColor(.textColor, for: .normal)
		button.setTitle(caption, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
		button.contentHorizontalAlignment = .left
		button.layer.cornerRadius = 16
		button.addTarget(
			self,
			action: #selector(nftCollectionButtonDidTap),
			for: .touchUpInside
		)
		
		let image = UIImage(systemName: "chevron.forward")
		let imageView = UIImageView(image: image)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.tintColor = .textColor
		button.addSubview(imageView)
		
		NSLayoutConstraint.activate([
			imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
			imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
		])
		
		return button
	}()
	
	// MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
	}
	
	// MARK: Private methods
	
	private func setupViews() {
		view.backgroundColor = .systemBackground
		[avatar, nameLabel, descriptionLabel,
		 navigateToUserWebsiteButton, nftCollectionButton].forEach {
			view.addSubview($0)
		}
		
		self.navigationItem.leftBarButtonItem = backButton
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			avatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			avatar.widthAnchor.constraint(equalToConstant: 70),
			avatar.heightAnchor.constraint(equalToConstant: 70),
			
			nameLabel.centerYAnchor.constraint(equalTo:avatar.centerYAnchor),
			nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
			
			
			descriptionLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 16),
			descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			descriptionLabel.heightAnchor.constraint(equalToConstant: 72),

			navigateToUserWebsiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
			navigateToUserWebsiteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			navigateToUserWebsiteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			navigateToUserWebsiteButton
				.heightAnchor.constraint(equalToConstant: 40),

			nftCollectionButton.topAnchor.constraint(equalTo: navigateToUserWebsiteButton.bottomAnchor, constant: 40),
			nftCollectionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			nftCollectionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			nftCollectionButton
				.heightAnchor.constraint(equalToConstant: 54),
		])
	}
	
	@objc func navigateToUserWebsiteButtonDidTap() {
		guard let website = viewModel?.user.website else {
			return
		}
		let webViewController = WebViewViewController()
		let controller = UINavigationController(rootViewController: webViewController)
		
		webViewController.viewModel = WebViewViewModel(url: website)
		controller.modalPresentationStyle = .fullScreen
		present(controller, animated: true)
	}
	
	@objc func nftCollectionButtonDidTap() {
		
	}
	
	@objc func backButtonDidTap() {
		dismiss(animated: true)
	}
}
