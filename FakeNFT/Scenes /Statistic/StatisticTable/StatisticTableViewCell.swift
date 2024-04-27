import UIKit

//MARK: - StatisticTableViewCell
final class StatisticTableViewCell: UITableViewCell {
    
    static let reusedIdentifier = "StatisticCell"
    
    private var user: UsersModel?
    
    private lazy var positionLabel: UILabel = {
        let positionLabel = UILabel()
        positionLabel.font = UIFont.sfProRegular15
        return positionLabel
    }()
    
    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = UIColor(resource: .ypLightGray)
        cardView.layer.cornerRadius = 12
        cardView.clipsToBounds = true
        return cardView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 14
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        return avatarImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.sfProBold22
        return nameLabel
    }()
    
    private lazy var countOfNftLabel: UILabel = {
        let countOfNftLabel = UILabel()
        countOfNftLabel.font = UIFont.sfProBold22
        return countOfNftLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        activateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getUser() -> UsersModel {
        
        guard let user = user else { return MockData.shared.placeholderUser }
        return user
    }
}

// MARK: - Add UI-Elements on View
extension StatisticTableViewCell {
    
    private func activateUI() {
        
        backgroundColor = UIColor(resource: .ypWhite)
        activateConstraints()
    }
    
    private func activateConstraints() {
        
        [positionLabel, cardView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [avatarImageView, nameLabel, countOfNftLabel].forEach {
            cardView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            //MARK: positionLabel
            positionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            positionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            //MARK: cardView
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            //MARK: avatarImageView
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            
            //MARK: nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            //MARK: countOfNftLabel
            countOfNftLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            countOfNftLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }
    
    func loadData(with user: UsersModel, position: Int) {
        
        self.user = user
        positionLabel.text = String(position)
        nameLabel.text = user.name
        countOfNftLabel.text = user.rating
        
        let placeholderAvatar = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(UIColor(resource: .ypGrayUn), renderingMode: .alwaysOriginal)
        let url = URL(string: user.avatar)
        avatarImageView.kf.setImage(with: url, placeholder: placeholderAvatar)
    }
}
