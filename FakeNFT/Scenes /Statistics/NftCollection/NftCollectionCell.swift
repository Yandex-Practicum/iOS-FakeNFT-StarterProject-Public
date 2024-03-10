import UIKit

protocol NftCollectionCellDelegate {
	func likeDidTap(id: String, isLiked: Bool)
	func cartDidTap(id: String, isAdded: Bool)
}

final class NftCollectionCell: UICollectionViewCell {
	
	// MARK: Public properties
	
	var viewModel: NftCollectionCellViewModel? {
		didSet {
			self.configureCell()
		}
	}
	var delegate: NftCollectionCellDelegate?
	
	// MARK: Private UI Properties
	
	private lazy var icon = {
		let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 108, height: 108))
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 12
		view.clipsToBounds = true
		
		return view
	}()
	
	private lazy var like = {
		let image = UIImage(named: "Like_no_active");
		let button = UIButton()
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(likeDidTap), for: .touchUpInside)
		
		return button
	}()
	
	private lazy var nameLabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .textColor
		label.textAlignment = .left
		label.font = .systemFont(ofSize: 17, weight: .bold)
		label.text = viewModel?.name ?? ""
		
		return label
	}()
	
	private lazy var rating = {
		let view = RatingView()
		
		return view
	}()
	
	private lazy var costLabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .textColor
		label.textAlignment = .left
		label.font = .systemFont(ofSize: 10, weight: .medium)
		label.text = getCost()
		
		return label
	}()
	
	private lazy var cart = {
		let image = UIImage(named: "Cart_add");
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(cartDidTap), for: .touchUpInside)
		
		return button
	}()
	
	// MARK: Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupViews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Private methods
	
	private func setupViews() {
		[icon, like, nameLabel, rating, costLabel, cart].forEach { view in
			contentView.addSubview(view)
		}
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			icon.topAnchor.constraint(equalTo: contentView.topAnchor),
			icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			icon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			icon.heightAnchor.constraint(equalToConstant: 108),
			
			like.topAnchor.constraint(equalTo: contentView.topAnchor),
			like.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			like.heightAnchor.constraint(equalToConstant: 40),
			like.widthAnchor.constraint(equalToConstant: 40),
			
			rating.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 8),
			rating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			rating.heightAnchor.constraint(equalToConstant: 12),
			rating.widthAnchor.constraint(equalToConstant: 68),
			
			nameLabel.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 5),
			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			nameLabel.heightAnchor.constraint(equalToConstant: 22),
			nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: cart.leadingAnchor),
			
			costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
			costLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			costLabel.trailingAnchor.constraint(lessThanOrEqualTo: cart.leadingAnchor),
			costLabel.heightAnchor.constraint(equalToConstant: 12),
			
			cart.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 4),
			cart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			cart.heightAnchor.constraint(equalToConstant: 40),
			cart.widthAnchor.constraint(equalToConstant: 40),
		])
	}
	
	private func configureCell() {
		guard let viewModel else {
			return
		}
		
		nameLabel.text = viewModel.name
		costLabel.text = getCost()
		rating.setRating(rating: viewModel.rating)

		let avatarUrl = URL(string: viewModel.iconUrl)
		let placeholderAvatarImage = UIImage(named: "UserAvatarPlaceholder")
		icon.kf.setImage(with: avatarUrl, placeholder: placeholderAvatarImage)
		
		setLiked()
		setOrdered()
		
		viewModel.$liked.bind { [weak self] _ in
			self?.setLiked()
		}
		viewModel.$ordered.bind { [weak self] _ in
			self?.setOrdered()
		}
	}
	
	private func setLiked() {
		guard let viewModel else {
			return
		}
		
		let image = UIImage(named: viewModel.liked ? "Like_active" : "Like_no_active")
		like.setImage(image, for: .normal)
	}
	
	private func setOrdered() {
		guard let viewModel else {
			return
		}
		let image = UIImage(named: viewModel.ordered ? "Cart_remove" : "Cart_add")
		cart.setImage(image, for: .normal)
	}
	
	private func getCost() -> String {
		guard let viewModel else {
			return "0 ETH"
		}
		return "\(viewModel.cost) ETH"
	}
	
	@objc private func likeDidTap() {
		guard let viewModel else {
			return
		}
		delegate?.likeDidTap(id: viewModel.id, isLiked: !viewModel.liked)
	}
	
	@objc private func cartDidTap() {
		guard let viewModel else {
			return
		}
		delegate?.cartDidTap(id: viewModel.id, isAdded: !viewModel.ordered)
	}
}
