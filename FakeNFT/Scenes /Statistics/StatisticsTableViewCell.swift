import UIKit
import Kingfisher

final class StatisticsTableViewCell: UITableViewCell {
	
	// MARK: Public Properties
	
	var viewModel: StatisticsTableViewCellViewModel? {
		didSet {
			guard let viewModel else {
				return
			}
			
			let user = viewModel.user
			let avatarUrl = URL(string: user.avatar)
			let placeholderAvatarImage = UIImage(named: "UserAvatarPlaceholder")
			
			positionLabel.text = viewModel.user.rating
			avatarImageView.kf.setImage(with: avatarUrl, placeholder: placeholderAvatarImage)
			nameLabel.text = user.name
			nftsCountLabel.text = "\(user.nfts.count)"
		}
	}
	
	// MARK: Private UI Properties
	
	private lazy var mainView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private lazy var positionLabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .textColor
		label.font = .systemFont(ofSize: 15, weight: .regular)
		
		return label
	}()
	
	private lazy var informationView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .statisticsCellBackground
		view.layer.cornerRadius = 12
		
		return view
	}()
	
	private lazy var avatarImageView = {
		let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = view.frame.width / 2
		view.clipsToBounds = true
		
		return view
	}()
	
	private lazy var nameLabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .textColor
		label.font = .systemFont(ofSize: 22, weight: .bold)
		
		return label
	}()
	
	private lazy var nftsCountLabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .textColor
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textAlignment = .right
		
		return label
	}()
	
	// MARK: Lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupViews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Private methods
	
	private func setupViews() {
		contentView.addSubview(mainView)
		mainView.addSubview(positionLabel)
		mainView.addSubview(informationView)
		informationView.addSubview(avatarImageView)
		informationView.addSubview(nameLabel)
		informationView.addSubview(nftsCountLabel)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
			mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			
			positionLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
			positionLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
			positionLabel.widthAnchor.constraint(equalToConstant: 27),
			
			informationView.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 8),
			informationView.topAnchor.constraint(equalTo: mainView.topAnchor),
			informationView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
			informationView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
			
			avatarImageView.centerYAnchor.constraint(equalTo: informationView.centerYAnchor),
			avatarImageView.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 16),
			avatarImageView.heightAnchor.constraint(equalToConstant: avatarImageView.frame.height),
			avatarImageView.widthAnchor.constraint(equalToConstant: avatarImageView.frame.width),
			
			nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
			nameLabel.centerYAnchor.constraint(equalTo: informationView.centerYAnchor),
			nameLabel.widthAnchor.constraint(equalToConstant: 186),
			
			nftsCountLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
			nftsCountLabel.centerYAnchor.constraint(equalTo: informationView.centerYAnchor),
			nftsCountLabel.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -16)
		])
	}
}
